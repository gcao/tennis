tournamentTypes = [
  'grandslam'
  'olympics'
  'atpfinal'
  'atp1000'
  'atp500'
  'daviscup'
  'other'
]

hotOpponents = []

window.config = {
  activeTypes    : tournamentTypes.slice(0)
  activeOpponents: 'all'
  allTypes: -> config.activeTypes.length is tournamentTypes.length
}

playerToClass = (player) -> player.replace(/\s/g, '_')

updateVisibility = ->
  $('.tournaments-by-year').show()
  $('#games-chart .tournament').show()
  $('#games-chart .game').hide().css('opacity', '')

  $('.tournament-types .toggleable').addClass('inactive')
  $.each config.activeTypes, ->
    $(".tournament-types .#{this}").removeClass('inactive')
  if config.allTypes()
    $('.tournament-types .all.toggleable').removeClass('inactive')
  else
    $('#games-chart .tournament').hide()
    $.each config.activeTypes, ->
      $("#games-chart .#{this}").show()

  $('.opponents .toggleable').addClass('inactive')
  if config.activeOpponents is 'all'
    $('.opponents .toggleable').removeClass('inactive')
    $('#games-chart .game').show()
  else
    $.each config.activeOpponents, ->
      cls = playerToClass this
      $(".opponents .#{cls}").removeClass('inactive')
      $("#games-chart .tournament.#{cls} .game").show().css('opacity', '0.15')
      $("#games-chart .tournament.#{cls} .game.#{cls}").css('opacity', '')

  $('#games-chart .tournament').each ->
    if $('.game', this).filter(':visible').length > 0
      $(this).show()
    else
      $(this).hide()

  $('.tournaments-by-year').each ->
    if $('.tournament', this).filter(':visible').length > 0
      $(this).show()
    else
      $(this).hide()

T.def 'tournament-types', (tournamentTypes) ->
  [ '.tournament-types'
    [ '.toggleable.all'
      click: ->
        if config.allTypes()
          config.activeTypes = []
        else
          config.activeTypes = tournamentTypes.slice(0)

        updateVisibility()

      'All'
    ]
    T.each 'tournament-type', tournamentTypes
  ]

T.def 'tournament-type', (type) ->
  [
    ".toggleable.tournament-type.#{type}"
    click: ->
      if config.activeTypes.indexOf(type) >= 0
        config.activeTypes.splice(config.activeTypes.indexOf(type), 1)
      else
        config.activeTypes.push type

      updateVisibility()

    translateType type
  ]

T.def 'opponents', (opponents) ->
  [ '.opponents'
    'Opponents: '
    [ '.toggleable.all'
      click: ->
        if config.activeOpponents.indexOf('all') >= 0
          config.activeOpponents = []
        else
          config.activeOpponents = "all"

        updateVisibility()

      'All'
    ]
    T.each 'opponent', opponents
  ]

T.def 'opponent', (opponent) ->
  cls = playerToClass opponent
  [
    ".toggleable.opponent.#{cls}"
    click: ->
      if config.activeOpponents is 'all'
        config.activeOpponents = hotOpponents.slice(0)
        config.activeOpponents.splice(config.activeOpponents.indexOf(opponent), 1)
      else if config.activeOpponents.indexOf(opponent) >= 0
        config.activeOpponents.splice(config.activeOpponents.indexOf(opponent), 1)
      else
        config.activeOpponents.push opponent

      updateVisibility()

    opponent
  ]

T.def 'games', ->
  [
    [ 'h2'
      #[ 'div'
      #  style: 
      #    'font-family': 'percentage'
      #  'ABC'
      #]
      'Games of '
      ['span.players']
      ': '
      T 'tournament-types', tournamentTypes
    ]
    T 'opponents', hotOpponents
    [ '.note'
      style: 
        'margin-top': 10 
        color: '#777'
      'Click any player below to toggle display mode between one player and all.'
    ]
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

  [ '.tournament'
    class: tournament.type
    for game in tournament.games
      class: playerToClass game.opponent

    [ '.tournament-info',
      ['span.type', translateType(tournament.type)]
      ['br']
      ['span.name', name]
    ]
    [ '.games'
      T.each_with_index('game', tournament.games)
    ]
  ]

T.def 'game', (game, index, tournament) ->
  if game.rank is 0
    return ['.game', 'BYE']

  [ '.game'
    class: playerToClass game.opponent

    if game.round is 'S'
      class: 'semifinal'
    else if game.round is 'F' or game.round is 'W'
      class: 'final'

    if game.result is 'W'
      class: 'win'
    else if game.result is 'L'
      class: 'lose'

    click: ->
      if config.activeOpponents.length is 1 and config.activeOpponents[0] is game.opponent
        config.activeOpponents = 'all'
      else
        config.activeOpponents = [game.opponent]

      updateVisibility()

    game.opponent
    " (#{game.rank})"
  ]

T.def 'tournaments-by-year', (year, tournaments) ->
  if not tournaments then return
  [ '.tournaments-by-year'
    ['.year', year]
    T.each('tournament', tournaments)
  ]

T.def 'tournaments', (tournaments) ->
  for year in ['2013'..'1998']
    T('tournaments-by-year', year, tournaments[year])

getHotOpponents = (data, max = 20) ->
  opponents = {}
  for year, tournaments of data
    for tournament in tournaments
      for game in tournament.games
        continue if game.opponent is ''
        opponents[game.opponent] ||= {name: game.opponent, matches:0, won:0}
        opponents[game.opponent].matches += 1
        opponents[game.opponent].won += 1 if game.result is 'W'

  values = (value for _, value of opponents)
  values = values.sort (v1, v2) -> v2.matches - v1.matches
  i = 0
  result = 
    for v in values
      break if v.matches < 10 and i >= max
      i += 1
      v.name
  result

showChart = (data) ->
  T('tournaments', data).render inside: '#games-chart'

loadDataAndShowChart = (player) ->
  loadData "#{player}_games", (result) ->
    hotOpponents = getHotOpponents(result.tournaments)
    T('games').render inside: '.main'
    $('.players').text(result.name)
    showChart result.tournaments

router.get '/games/:player', (req) ->
  loadDataAndShowChart(req.params.player)

