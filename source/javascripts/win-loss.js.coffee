#= require vendor/d3.v2.min

loadWinLoss = (players) ->
  ids = $.map(players, (player) -> player + '_win_loss')
  loadData2(ids)

playerDataOfYearIsEmpty = (data, year) ->
  isEmpty = true
  for d in data
    if d[0] is year and (d[1] isnt 0 or d[2] isnt 0)
      isEmpty = false
      break
  isEmpty

players = getPlayers(DEFAULT_PLAYERS)
loadWinLoss(players).then (results...) ->
  results = normalizeResults results
  console.log results

  margin =
    top    : 20
    right  : 20
    bottom : 30
    left   : 40

  width  = 960 - margin.left - margin.right
  height = 550 - margin.top - margin.bottom
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

  for result, playerIndex in results
    data  = result.data
    years = (d[0] for d in data)

    player = svg.selectAll(".player#{playerIndex}")
      .data(data)
      .enter()
      .append("g")
      .attr("class"    , "player player#{playerIndex}")
      .attr("transform", (d) -> "translate(" + x(d[0]) + ", 0)")

    x1 = d3.scale.ordinal()
      .domain(i for _, i in results)
      .rangeRoundBands([0, x.rangeBand()], .05)

    barX = (d, i) ->
      return 21 if results.length is 1

      barIndex = playerIndex

      # Move player1's bar close to right if player2's win/loss is 0
      if playerIndex is 0 and results.length > 1
        barIndex = 1 if playerDataOfYearIsEmpty results[1].data, d[0]
      # Move player4's bar close to right if player3's win/loss is 0
      else if playerIndex is 3
        barIndex = 2 if playerDataOfYearIsEmpty results[2].data, d[0]

      x1(barIndex)

    barWidth =
      if results.length is 1
        Math.min(x.rangeBand(), 30)
      else
        x1.rangeBand()

    # Win/loss bar
    player.selectAll(".win")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "win")
      .attr("x"     , barX)
      .attr("y"     , (d) -> y d[1])
      .attr("width" , barWidth)
      .attr "height", (d) ->
        y(0) - y(d[1])

    player.selectAll(".loss")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "loss")
      .attr("x"     , barX)
      .attr("y"     , (d) -> y d[1] + d[2])
      .attr("width" , barWidth)
      .attr "height", (d) ->
        h = y(d[1]) - y(d[1] + d[2])
        if h > 0 then h - 1 else h

    # Win percentage
    player.selectAll(".percentage")
      .data((d) -> [d])
      .enter()
      .append("circle")
      .attr("class", "percentage")
      .attr("r"    , (d) -> if d[1] is 0 and d[2] is 0 then 0 else 3)
      .attr("cx"   , (d, i) -> 35)
      .attr "cy"   , (d) ->
        if d[1] is 0 and d[2] is 0
          0
        else
          y(50 + 100 * d[1] / (d[1] + d[2]))

    if results.length is 1
      player.append("text")
        .text((d) -> d3.format("%d") d[1] / (d[1] + d[2]))
        .attr("x", (d, i) -> 20)
        .attr("y", (d) -> y(50 + 100 * d[1] / (d[1] + d[2])) - 10)

    # Win percentage line
    line = d3.svg.line()
      .x((d) -> x(d[0]) + 35)
      .y((d) -> y(50 + 100 * d[1] / (d[1] + d[2])))

    linesData = (d for d in data when d[1] isnt 0 or d[2] isnt 0)
    lines = svg.selectAll(".line#{playerIndex}")
      .data([linesData])
      .enter()
      .append("g")
      .attr("class", "line line#{playerIndex}")
      .append("path")
      .attr("d", line)

