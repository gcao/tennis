tmpl.tournaments = ->
  [
    ['p', 'Please zoom in to see ATP500 and ATP250 tournaments.']
    ['#map']
    ['p', 'Please zoom in to see ATP500 and ATP250 tournaments.']
  ]

router.get '/tournaments', ->
  T(tmpl.tournaments).render inside: '.main'

  loadData "tournaments", (tournaments) ->
    map = getMap()
    atp500Markers = []
    atp250Markers = []
    $.each tournaments.data, (i, tournament) ->
      return  if tournament.type is "daviscup"

      icon     = getTournamentLogo(tournament.type, tournament.name)
      zIndex   = getTournamentPriority(tournament.type)
      show     = not(tournament.type in ["atp250", "atp500"])
      position = new google.maps.LatLng(tournament.latitude, tournament.longitude)
      marker   = new google.maps.Marker(
        position : position
        map      : (if show then map else null)
        icon     : icon
        zIndex   : zIndex
      )

      switch tournament.type 
        when "atp250" then atp250Markers.push marker
        when "atp500" then atp500Markers.push marker

      infoWindow = new google.maps.InfoWindow(content: T(tmpl.tournamentInfoWindow, tournament).toString())
      google.maps.event.addListener marker, "click", ->
        infoWindow.open map, marker

    google.maps.event.addListener map, "zoom_changed", ->
      zoom = map.getZoom()
      if zoom <= 4
        $.each atp250Markers, (i, marker) ->
          marker.setMap null
      else
        $.each atp250Markers, (i, marker) ->
          marker.setMap map

      if zoom <= 3
        $.each atp500Markers, (i, marker) ->
          marker.setMap null
      else
        $.each atp500Markers, (i, marker) ->
          marker.setMap map

