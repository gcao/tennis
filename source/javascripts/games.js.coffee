T.def 'games', (grandSlam, players) ->
  [
    [ 'h2'
      'Games of '
      ['span.players']
      #['span.note', ' Click name to toggle']
    ]
    #[ 'form#games-form'
    #  action: '/games'
    #  method: 'get'
    #  ['input', type: 'hidden', name: 'players']
    #  [ 'input#grandSlam'
    #    type: 'checkbox'
    #    name: 'grandSlam'
    #    value: 'true'
    #    click: -> 
    #      route = "#/games/#{players.join(',')}"
    #      if $(this).is(':checked') then route += '?grandSlam'
    #      window.location.hash = route
    #    renderComplete: (el) ->
    #      if grandSlam
    #        $(el).attr('checked', 'checked')
    #  ]
    #  [ 'label'
    #    for: 'grandSlam'
    #    ' Use Grand Slam data'
    #  ]
    #]
    ['#games-chart']
  ]

T.def 'games-player', (player, i) ->
  [ "span.player#{i}",
    click: -> $("#games-chart .player#{i}").toggleClass('hide')
    player.name
    '&nbsp;&nbsp;'
  ]

loadGames = (players) ->
  ids = $.map(players, (player) -> player + '_games')
  loadData2(ids)

showGames = (grandSlam, results...) ->
  T.each_with_index('games-player', results).render inside: '.players'

router.get '/games/:players', (req) ->
  players = req.params.players.split(',')
  grandSlam = req.params.grandSlam

  T('games', grandSlam, players).render inside: '.main'

  loadGames(players).then (results...) ->
    showGames grandSlam, results...

