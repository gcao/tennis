#= require vendor/d3.v2.min

loadWinLoss = (players) ->
  ids = $.map(players, (player) -> player + '_win_loss')
  loadData2(ids)

players = getPlayers(DEFAULT_PLAYERS)
players = ['roger_federer', 'novak_djokovic']
loadWinLoss(players).then (results...) ->
  results = normalizeResults results

  margin =
    top    : 20
    right  : 20
    bottom : 30
    left   : 40

  width  = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom
  years  = [2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013]

  x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1)
    .domain(years)

  y = d3.scale.linear()
    .rangeRound([height, 0])
    .domain([0, 150])

  xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")

  svg = d3.select("#win-loss-chart")
    .append("svg")
    .attr("width" , width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

  svg.append("g")
    .attr("class"    , "x axis")
    .attr("transform", "translate(0, " + height + ")")
    .call(xAxis)

  # Add horizontal grids
  hGrid = svg.selectAll('.h-grid')
    .data([0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, .6, .7, .8, .9, 1])
    .enter()
    .append('g')
    .attr('class', 'h-grid');

  hGrid.append('line')
    .attr('x1', (d, i) -> 0)
    .attr('y1', (d, i) -> y(i * 10))
    .attr('x2', (d, i) -> width)
    .attr('y2', (d, i) -> y(i * 10))

  hGrid.append('text')
    .text((d, i) -> if i <= 10 then d else d3.format('%d')(d))
    .attr('x', (d, i) -> -5)
    .attr('y', (d, i) -> y(i * 10))
    .attr('text-anchor', 'end')

  $.each results, (playerIndex, result) ->
    data  = result.data
    years = $.map(data, (d) -> d[0])

    player = svg.selectAll(".player#{playerIndex}")
      .data(data)
      .enter()
      .append("g")
      .attr("class"    , "player player#{playerIndex}")
      .attr("transform", (d) -> "translate(" + x(d[0]) + ", 0)")

    x1 = d3.scale.ordinal()
      .domain($.map(results, (result, i) -> i))
      .rangeRoundBands([0, x.rangeBand()], .05)

    # Win/loss bar
    player.selectAll(".win")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "win")
      .attr("x"     , (d) -> x1(playerIndex))
      .attr("y"     , (d) -> y d[1])
      .attr("width" , x1.rangeBand())
      .attr("height", (d) -> y(0) - y(d[1]))

    player.selectAll(".loss")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "loss")
      .attr("x"     , (d) -> x1(playerIndex))
      .attr("y"     , (d) -> y d[1] + d[2])
      .attr("width" , x1.rangeBand())
      .attr "height", (d) -> 
        h = y(d[1]) - y(d[1] + d[2])
        if h > 0 then h - 1 else h

    # Win percentage
    player.selectAll(".percentage")
      .data((d) -> [d])
      .enter()
      .append("circle")
      .attr("class", "percentage")
      .attr("r"    , 3)
      .attr("cx"   , (d, i) -> 35)
      .attr("cy"   , (d) -> y 50 + 100 * d[1] / (d[1] + d[2]))

    if results.length is 1
      player.append("text")
        .text((d) -> d3.format("%d") d[1] / (d[1] + d[2]))
        .attr("x", (d, i) -> 20)
        .attr("y", (d) -> y(50 + 100 * d[1] / (d[1] + d[2])) - 10)
    
    # Win percentage line
    line = d3.svg.line()
      .x((d) -> x(d[0]) + 35)
      .y((d) -> y(50 + 100 * d[1] / (d[1] + d[2])))

    lines = svg.selectAll(".line#{playerIndex}")
      .data([data])
      .enter()
      .append("g")
      .attr("class", "line line#{playerIndex}")
      .append("path")
      .attr("d", line)

