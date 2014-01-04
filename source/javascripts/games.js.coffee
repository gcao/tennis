toggleTournaments = (type) ->
  $(".tournament-types .#{type}").toggleClass('inactive')
  $("#games-chart .#{type}").toggle()

createTogglePlayerHandler = (player) ->
  cls = playerToClass(player)
  ->
    $(".opponent.toggleable.#{cls}").toggleClass('inactive')
    $("#games-chart .#{cls}").toggle()
    hideTournaments()

playerToClass = (player) ->
  player.replace(/\s/g, '_')

hideTournaments = ->
  $('.tournament, .tournaments-by-year').show()

  $('.tournament').each ->
    if $('.game', this).filter(':visible').get(0)
      $(this).show()
    else
      $(this).hide()

  $('.tournaments-by-year').each ->
    if $('.tournament', this).filter(':visible').get(0)
      $(this).show()
    else
      $(this).hide()

T.def 'tournament-type', (type) ->
  [ 'div.toggleable'
    class: type
    click: -> toggleTournaments(type)
    translateType type
  ]

T.def 'opponents', (opponents) ->
  [ 'div.opponents'
    'Opponents: '
    [ 'div.all.toggleable'
      click: ->
        $('.all.toggleable').toggleClass('inactive')
        if $('.all.toggleable').hasClass('inactive')
          $('.opponent.toggleable').addClass('inactive')
          $('#games-chart .game').hide()
        else
          $('.opponent.toggleable').removeClass('inactive')
          $('#games-chart .game').show()

        hideTournaments()

      'All'
    ]
    [ 'div.individuals'
      style: display: 'inline-block'
      for opponent in opponents
        opponentClass = playerToClass opponent
        [ 'div.toggleable.opponent'
          class: opponentClass
          click: createTogglePlayerHandler(opponent)
          opponent
        ]
    ]
  ]

T.def 'games', ->
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
    T('opponents', ['Rafael Nadal', 'Novak Djokovic', 'Andy Murray'])
    ['#games-chart']
  ]

translateType = (type) ->
  switch type
    when 'grandslam' then 'Grand Slam'
    when 'olympics'  then 'Olympics'
    when 'atpfinal'  then 'ATP Tour Finals'
    when 'atp1000'   then 'ATP 1000'
    when 'atp500'    then 'ATP 500'
    when 'daviscup'  then 'Davis Cup'
    when 'other'     then 'Other'
    else type

T.def 'tournament', (tournament) ->
  name = tournament.name
  if tournament.type is 'atpfinal'
    name = 'ATP Tour Finals'
  else if tournament.type is 'atp1000'
    name = name.replace /ATP World Tour Masters 1000|ATP Masters Series /, '' 

  [ 'div.tournament'
    class: tournament.type
    #for game in tournament.games
    #  class: playerToClass game.opponent

    [ 'div.tournament-info', 
      ['span.type', translateType(tournament.type)] 
      ['br']
      ['span.name', name]
    ]
    [ 'div.games'
      T.each_with_index('game', tournament.games)
    ]
  ]

T.def 'game', (game, index, tournament) ->
  if game.rank is 0
    return ['div.game', 'BYE']

  [ 'div.game'
    class: playerToClass game.opponent

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

T.def 'tournaments-by-year', (year, tournaments) ->
  if not tournaments then return
  [ 'div.tournaments-by-year'
    ['div.year', year]
    T.each('tournament', tournaments)
  ]

T.def 'tournaments', (tournaments) ->
  for year in ['2013'..'1998']
    T('tournaments-by-year', year, tournaments[year])

showChart = (data) ->
  T('tournaments', data).render inside: '#games-chart'

loadDataAndShowChart = (player) ->
  loadData "#{player}_games", (result) ->
    $('.players').text(result.name)
    showChart result.tournaments

router.get '/games/:player', (req) ->
  T('games').render inside: '.main'

  loadDataAndShowChart(req.params.player)

