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

$.when(loadData('tournaments'), loadData(player + '_schedule')).then (req1, req2) ->
  tournaments = req1[0]
  schedule = req2[0]
  map = new google.maps.Map(document.getElementById("map"),
    zoom: 3
    center: new google.maps.LatLng(20, 0)
    mapTypeId: google.maps.MapTypeId.TERRAIN
  )

  tournaments = $.map(schedule.data, (tournament_name) ->
    result = tournaments.data.filter((tournament) ->
      tournament.name is tournament_name
    )
    if result.length > 0
      result[0]
    else
      console.log "Tournament not found: " + tournament_name  if console.log
  )

  prevMarker = undefined
  $.each tournaments, (i, tournament) ->
    icon = ""
    zIndex = 1
    if tournament.type is "atp250"
      icon = "http://www.atpworldtour.com/~/media/810218DC73784BEEA6EF0978B2842A69.ashx?w=31&h=36"
      zIndex = 2
    else if tournament.type is "atp500"
      icon = "http://www.atpworldtour.com/~/media/1DB04CA8505648B7B511FA1E37F1E3BA.ashx?w=31&h=36"
      zIndex = 3
    else if tournament.type is "atp1000"
      icon = "http://www.atpworldtour.com/~/media/F5219431817E4ED3B773BF9B006A9ACF.ashx?w=31&h=42"
      zIndex = 4
    else if tournament.type is "atptourfinal"
      icon = "http://www.atpworldtour.com/~/media/47F12472FD254B08B57755E5B7565E5D.ashx?w=31&h=48"
      zIndex = 5
    else if tournament.type is "grandslam"
      zIndex = 6
      if tournament.name.match(/australian open/i)
        icon = new google.maps.MarkerImage("images/ao_logo.png")
      else if tournament.name.match(/roland garros/i)
        icon = new google.maps.MarkerImage("images/fo_logo.png")
      else if tournament.name.match(/wimbledon/i)
        icon = new google.maps.MarkerImage("images/wo_logo.png")
      else icon = new google.maps.MarkerImage("images/uo_logo.png")  if tournament.name.match(/us open/i)
    else return  if tournament.type is "daviscup"
    label = "<div class=\"map-info\">" + "<p class=\"tournament-name\"><a href=\"http://www.atpworldtour.com" + tournament.url + "\" target=\"_new\">" + tournament.name + "</a>" + "</p><p><span class=\"tournament-time\">" + tournament.start + "</span> @ <span class=\"tournament-place\">" + tournament.place + "</span></p><p class=\"tournament-title-holder\">Title Holder: <a href=\"http://www.atpworldtour.com" + tournament.title_holder.url + "\" target=\"_new\">" + tournament.title_holder.name + "</a>" + "</p></div>"
    myLatLng = new google.maps.LatLng(tournament.latitude, tournament.longitude)
    marker = new google.maps.Marker(
      position: myLatLng
      map: map
      icon: icon
      zIndex: zIndex
    )
    infoWindow = new google.maps.InfoWindow(content: label)
    google.maps.event.addListener marker, "click", ->
      infoWindow.open map, marker

    addPath map, prevMarker, marker  if prevMarker
    prevMarker = marker
