templates = {}

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

templates.tournamentTypes = (tournamentTypes) ->
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
    T.each templates.tournamentType, tournamentTypes
  ]

templates.tournamentType = (type) ->
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

templates.opponents = (opponents) ->
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
    T.each templates.opponent, opponents
    [ '#opponents-graph'
      ['.content']
    ]
  ]

templates.opponent = (opponent) ->
  name = opponent.name
  cls = playerToClass name
  [
    ".toggleable.opponent.#{cls}"
    click: ->
      if config.activeOpponents is 'all'
        config.activeOpponents = (player.name for player in hotOpponents)
        config.activeOpponents.splice(config.activeOpponents.indexOf(name), 1)
      else if config.activeOpponents.indexOf(name) >= 0
        config.activeOpponents.splice(config.activeOpponents.indexOf(name), 1)
      else
        config.activeOpponents.push name

      updateVisibility()

    name
    " ("
    [ "span"
      style: 
        font_weight: 'bold'
      "#{opponent.won}/#{opponent.matches}"
    ]
    ")"
  ]

templates.games = ->
  [
    [ 'h2'
      'Games of '
      ['span.players']
      ': '
      T templates.tournamentTypes, tournamentTypes
    ]
    T templates.opponents, hotOpponents
    [ '.note'
      style: 
        margin_top: 10 
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

templates.tournament = (tournament) ->
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
      T.eachWithIndex(templates.game, tournament.games)
    ]
  ]

templates.game = (game, index, tournament) ->
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

templates.tournamentsByYear = (year, tournaments) ->
  if not tournaments then return
  [ '.tournaments-by-year'
    ['.year', year]
    T.each(templates.tournament, tournaments)
  ]

templates.tournaments = (tournaments) ->
  curYear = '' + (new Date().getYear() + 1900)
  for year in [curYear..'1998']
    T(templates.tournamentsByYear, year, tournaments[year])

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
      v
  result

# Opponents diagram
# http://jsfiddle.net/LjsnD/
# https://bl.ocks.org/kgeorgiou/68f864364f277720252d0329408433ae
drawOpponentsGraph = (opponents) ->
  width = 720
  height = 480
  padding = 2
  minRadius = 20
  maxRadius = 50

  minMatches = Math.min(opponents.map((o) -> o.matches)...)
  maxMatches = Math.max(opponents.map((o) -> o.matches)...)

  nodes = opponents.map((opponent) -> 
    {
      radius: minRadius + (maxRadius - minRadius) * (opponent.matches - minMatches) / (maxMatches - minMatches)
      color: d3.rgb(255 * opponent.won / opponent.matches, 255 * (1 - opponent.won / opponent.matches), 0)
    }
  )

  tick = (e) ->
    node.each(collide(.5)).attr('cx', (d) -> d.x).attr('cy', (d) -> d.y)
    return

  # Resolves collisions between d and all other circles.

  collide = (alpha) ->
    quadtree = d3.geom.quadtree(nodes)
    (d) ->
      r = d.radius + maxRadius + padding
      nx1 = d.x - r
      nx2 = d.x + r
      ny1 = d.y - r
      ny2 = d.y + r
      quadtree.visit (quad, x1, y1, x2, y2) ->
        `var r`
        if quad.point and quad.point != d
          x = d.x - (quad.point.x)
          y = d.y - (quad.point.y)
          l = Math.sqrt(x * x + y * y)
          r = d.radius + quad.point.radius + (if d.cluster == quad.point.cluster then padding else clusterPadding)
          if l < r
            l = (l - r) / l * alpha
            d.x -= x *= l
            d.y -= y *= l
            quad.point.x += x
            quad.point.y += y
        x1 > nx2 or x2 < nx1 or y1 > ny2 or y2 < ny1
      return

  force = d3.layout.force()
    .nodes(nodes)
    .size([width, height])
    .gravity(.02)
    .charge(0)
    .on('tick', tick)
    .start()
  svg = d3.select('#opponents-graph .content')
    .append('svg')
    .attr('width', width)
    .attr('height', height)
  grads = svg.append('defs')
    .selectAll('radialGradient')
    .data(nodes)
    .enter()
    .append('radialGradient')
    .attr('gradientUnits', 'objectBoundingBox')
    .attr('cx', 0)
    .attr('cy', 0)
    .attr('r', '100%')
    .attr('id', (d, i) -> 'grad' + i)
  grads.append('stop')
    .attr('offset', '0%')
    .style('stop-color', 'white')
  grads.append('stop')
    .attr('offset', '100%')
    .style('stop-color', (d) -> d.color)
  node = svg.selectAll('circle')
    .data(nodes)
    .enter()
    .append('circle')
    .style('fill', (d, i) -> 'url(#grad' + i + ')')
    .call(force.drag)
  node.transition()
    .duration(750)
    .delay((d, i) -> i * 5)
    .attrTween('r', (d) ->
      i = d3.interpolate(0, d.radius)
      (t) -> d.radius = i(t)
    )

showChart = (data) ->
  T(templates.tournaments, data).render inside: '#games-chart'

loadDataAndShowChart = (player) ->
  loadData "#{player}_games", (result) ->
    hotOpponents = getHotOpponents(result.tournaments)
    T(templates.games).render inside: '.main'
    $('.players').text(result.name)
    showChart result.tournaments
    drawOpponentsGraph(hotOpponents)

router.get '/games/:player', (req) ->
  loadDataAndShowChart(req.params.player)
