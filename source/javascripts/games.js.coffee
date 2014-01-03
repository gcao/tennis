toggleTournaments = (type) ->
  $(".tournament-types .#{type}").toggleClass('inactive')
  $("#games-chart .#{type}").toggle()

T.def 'tournament-type', (type) ->
  [ 'div'
    class: type
    click: -> toggleTournaments(type)
    translateType type
  ]
T.def 'games', () ->
  [
    [ 'h2'
      'Games of '
      ['span.players']
      ': '
      ['.tournament-types'
        T.each 'tournament-type', [
          'grandslam'
          'olympics'
          'atpfinal'
          'atp1000'
          'atp500'
          'daviscup'
          'other'
        ]
      ]
    ]
    ['#games-chart']
  ]

translateType = (type) ->
  switch type
    when 'grandslam' then 'Grand Slam'
    when 'atpfinal' then 'ATP Tour Final'
    when 'atp1000' then 'ATP 1000'
    when 'atp500' then 'ATP 500'
    when 'daviscup' then 'Davis Cup'
    when 'othe' then 'Other'
    else type

T.def 'tournament', (tournament) ->
  name = tournament.name
  if tournament.type is 'atpfinal'
    name = 'ATP Tour Finals'
  else if tournament.type is 'atp1000'
    name = name.replace /ATP World Tour Masters 1000|ATP Masters Series /, '' 

  [ 'div.tournament'
    class: tournament.type
    #[ 'div.type', translateType(tournament.type) ]
    [ 'div.name', name ]
    [ 'div.games'
      T.each_with_index('game', tournament.games)
    ]
  ]

T.def 'game', (game, index, tournament) ->
  if game.rank is 0
    return ['div.game', 'BYE']

  [ 'div.game'

    if game.round is 'S'
      class: 'semifinal'
    else if game.round is 'F' or game.round is 'W'
      class: 'final'

    if game.result is 'W'
      class: 'win'
    else if game.result is 'L'
      class: 'lose'

    game.opponent
    " (#{game.rank})"
  ]

T.def 'tournaments', (year, tournaments) ->
  [
    ['div.year', year]
    T.each('tournament', tournaments)
  ]

showChart = (data) ->
  for year, tournaments of data
    T('tournaments', year, tournaments).render inside: '#games-chart'

loadDataAndShowChart = (player) ->
  loadData "#{player}_games", (result) ->
    $('.players').text(result.name)
    showChart result.tournaments

router.get '/games/:player', (req) ->
  T('games').render inside: '.main'

  loadDataAndShowChart(req.params.player)

