T.def 'schedule', ->
  [
    [ 'h2'
      ['span#player_name']
      "'s tournament schedule"
    ]
    ['#map']
    ['#schedule']
  ]

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

  pLine = new google.maps.Polyline
    map: map
    path: fPoints
    strokeColor: strokeColor
    strokeWeight: 3
    strokeOpacity: 1

window.filterTournaments = (tournaments, schedule) ->
  $.map schedule, (x) ->
    result = tournaments.filter (tournament) ->
      tournament.name is x.tournament

    if result.length > 0
      tournament = result[0]
      tournament.result = x.result
      tournament.defeated = x.defeated
      tournament.lost_to = x.lost_to
      tournament
    else
      console?.log "Tournament not found: " + x.tournament


window.drawMapWithSchedule = (tournaments) ->
  window.map = getMap()
  prevTournament = undefined
  prevMarker = undefined
  for tournament, i in tournaments
    continue  if tournament.type is "daviscup"

    icon     = getTournamentLogo(tournament.type, tournament.name)
    zIndex   = getTournamentPriority(tournament.type)
    position = new google.maps.LatLng(tournament.latitude, tournament.longitude)
    marker   = new google.maps.Marker
      position: position
      map: map
      icon: icon
      zIndex: zIndex

    infoWindow = new google.maps.InfoWindow content: T('tournament-info-window', tournament).toString()
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
    else              ''

T.def 'tournament-result', (data) ->
  return unless data.result

  [ "div.detail"
    [ "table"
      [ "tr"
        ["td", "Result"]
        ["td", data.result]
      ]
      if data.defeated
        [ "tr"
          ["td", "Defeated"]
          ["td", data.defeated]
        ]
      if data.lost_to
        [ "tr"
          ["td", "Lost to"]
          ["td", data.lost_to]
        ]
    ]
  ]

T.def 'tournament', (tournament) ->
  tournamentUrl  = getAtpUrl(tournament.url)
  tournamentLogo = getTournamentLogo(tournament.type, tournament.name)
  statusClass    = if isFuture(tournament.start) then 'future' else ''
  resultClass    = translateResult(tournament.result)
  [ 'div.tournament'
    {class: "#{statusClass} #{resultClass}"}
    ['div.start', tournament.start]
    [ 'div.logo'
      [ 'a'
        href: tournamentUrl
        target: '_new'
        ['img', src:tournamentLogo]
      ]
    ]
    [ 'div.name'
      [ 'a'
        href: tournamentUrl
        target: '_new'
        tournament.name
      ]
      '&nbsp;&nbsp;'
      T('buy-ticket-link', tournament, getTicketUrl(tournament.name))
    ]
    T('tournament-result', tournament)
  ]

window.setMapCenterToTournament = (tournament) ->
  map.setCenter(new google.maps.LatLng(tournament.latitude, tournament.longitude))

router.get '/schedule/:player', (req) ->
  console.log 'schedule'

  T('schedule').render inside: '.main'

  player = req.params.player
  if player
    $.when(loadData('tournaments'), loadData(player + '_schedule')).then (req1, req2) ->
      tournaments = req1[0]
      schedule = req2[0]

      $('#player_name').text(schedule.name)

      # tournament: 'ABC', result: 'W/F/SF/QF/1/16', defeated: 'A, B etc', lost_to: ''
      schedule = $.map(schedule.data, (x) -> if typeof x is 'string' then {tournament: x} else x)

      tournaments = filterTournaments(tournaments.data, schedule)
      drawMapWithSchedule(tournaments)
      T.each('tournament', tournaments).render inside: '#schedule'
  else
    $('#map, #schedule').hide()
    $('.main h2').html('No player is selected. Please select players from "Schedules" menu')

