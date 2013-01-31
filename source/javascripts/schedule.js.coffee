addPath = (map, startMarker, endMarker) ->
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

  pLine = new google.maps.Polyline(
    map: map
    path: fPoints
    strokeColor: "#FF9601"
    strokeWeight: 3
    strokeOpacity: 1
  )

window.filterTournaments = (tournaments, schedule) ->
  $.map(schedule, (tournament_name) ->
    result = tournaments.filter((tournament) ->
      tournament.name is tournament_name
    )
    if result.length > 0
      result[0]
    else
      console?.log "Tournament not found: " + tournament_name
  )

window.drawMapWithSchedule = (tournaments) ->
  map = getMap()
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

    addPath map, prevMarker, marker  if prevMarker
    prevMarker = marker
