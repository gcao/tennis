addPath = (map, startMarker, endMarker, pathState) ->
  bounds = new google.maps.LatLngBounds()
  p1 = startMarker.getPosition()
  p2 = endMarker.getPosition()
  bounds.extend p1
  bounds.extend p2
  fPoints = new Array()
  PI = Math.PI
  sin = Math.sin
  asin = Math.asin
  cos = Math.cos
  atan2 = Math.atan2
  pow = Math.pow
  sqrt = Math.sqrt
  lat1 = p1.lat() * (PI / 180)
  lon1 = p1.lng() * (PI / 180)
  lat2 = p2.lat() * (PI / 180)
  lon2 = p2.lng() * (PI / 180)
  d = 2 * asin(sqrt(pow((sin((lat1 - lat2) / 2)), 2) + cos(lat1) * cos(lat2) * pow((sin((lon1 - lon2) / 2)), 2)))
  bearing = atan2(sin(lon1 - lon2) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon1 - lon2)) / -(PI / 180)
  bearing = (if bearing < 0 then 360 + bearing else bearing)
  n = 0

  while n < 51
    f = (1 / 50) * n
    f = f.toFixed(6)
    A = sin((1 - f) * d) / sin(d)
    B = sin(f * d) / sin(d)
    x = A * cos(lat1) * cos(lon1) + B * cos(lat2) * cos(lon2)
    y = A * cos(lat1) * sin(lon1) + B * cos(lat2) * sin(lon2)
    z = A * sin(lat1) + B * sin(lat2)
    latN = atan2(z, sqrt(pow(x, 2) + pow(y, 2)))
    lonN = atan2(y, x)
    p = new google.maps.LatLng(latN / (PI / 180), lonN / (PI / 180))
    fPoints.push p
    n++

  strokeColor = switch pathState
    when 'past'    then '#888'
    when 'present' then '#f44'
    else                '#FF9601'
  pLine = new google.maps.Polyline(
    map: map
    path: fPoints
    strokeColor: strokeColor
    strokeWeight: 3
    strokeOpacity: 1
  )

window.filterTournaments = (tournaments, schedule) ->
  $.map(schedule, (x) ->
    result = tournaments.filter((tournament) ->
      tournament.name is x.tournament
    )
    if result.length > 0
      tournament = result[0]
      tournament.extras = x
      tournament
    else
      console?.log "Tournament not found: " + x.tournament
  )

window.drawMapWithSchedule = (tournaments) ->
  window.map = getMap()
  prevTournament = undefined
  prevMarker = undefined
  $.each tournaments, (i, tournament) ->
    return  if tournament.type is "daviscup"

    icon     = getTournamentLogo(tournament.type, tournament.name)
    zIndex   = getTournamentPriority(tournament.type)
    position = new google.maps.LatLng(tournament.latitude, tournament.longitude)
    marker   = new google.maps.Marker(
      position: position
      map: map
      icon: icon
      zIndex: zIndex
    )

    infoWindow = new google.maps.InfoWindow(content: getInfoWindowContent(tournament))
    google.maps.event.addListener marker, "click", ->
      infoWindow.open map, marker

    if prevTournament
      pathState =
        if isFuture(prevTournament.start) then 'future'
        else if not isFuture(tournament.start) then 'past'
        else 'present'

      addPath map, prevMarker, marker, pathState

    prevTournament = tournament
    prevMarker = marker

translateResult = (result) ->
  switch result
    when 'W'     then 'won'
    when 'F'     then 'final'
    when 'SF'    then 'semi-final'
    when 'QF'    then 'quarter-final'
    when '1/16'  then 'round-of-16'
    when '1/32'  then 'round-of-32'
    when '1/64'  then 'round-of-64'
    when '1/128' then 'round-of-128'
    else ''

window.tournamentRowTemplate = (data) ->
  ["div.detail",
    ["table"
      if data.result then ["tr"
        ["td", "Result"]
        ["td", data.result]
      ]
      if data.defeated then ["tr"
        ["td", "Result"]
        ["td", data.defeated]
      ]
      ["tr"
        ["td", "Result"]
        ["td", data.lost_to]
      ]
    ]
  ]

generateDetail = (tournament) ->
  extras = tournament.extras
  return unless extras

  detail = "<div class=\"detail\"><table>"
  detail += "<tr><td>Result</td><td>#{extras.result}</td></tr>" if extras.result
  detail += "<tr class=\"defeated\"><td>Defeated</td><td>#{extras.defeated}</td></tr>" if extras.defeated
  detail += "<tr class=\"lost-to\"><td>Lost to</td><td>#{extras.lost_to}</td></tr>" if extras.lost_to
  detail + "</table></div>"

window.generateScheduleHtml = (tournaments) ->
  html = ""
  $.each tournaments, (i, tournament) ->
    tournamentUrl = getAtpUrl(tournament.url)
    tournamentLogo = getTournamentLogo(tournament.type, tournament.name)
    statusClass = if isFuture(tournament.start) then 'future' else ''
    resultClass = translateResult(tournament.extras?.result)
    html += """
      <div class="tournament #{statusClass} #{resultClass}">
        <div class="start">#{tournament.start}</div>
        <div class="logo"><a href="#{tournamentUrl}" target="_new"><img src="#{tournamentLogo}"/></a></div>
        <div class="name"><a href="#{tournamentUrl}" target="_new">#{tournament.name}</a></div>
        #{generateDetail(tournament)}
      </div>
    """

  html

window.setMapCenterToTournament = (tournament) ->
  map.setCenter(new google.maps.LatLng(tournament.latitude, tournament.longitude))
