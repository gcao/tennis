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

  x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1)
    .domain(results[0].data.map((d) -> d[0]))

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

  # Win/loss bar
  barWidth = Math.min(x.rangeBand(), 30)
  barX     = 42 - (x.rangeBand() - barWidth)/2

  $.each results, (i, result) ->
    data = result.data

    year = svg.selectAll(".year#{i}")
      .data(data)
      .enter()
      .append("g")
      .attr("class"    , "year year#{i}")
      .attr("transform", (d) -> "translate(" + x(d[0]) + ", 0)")

    year.selectAll(".win")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "win")
      .attr("x"     , barX)
      .attr("y"     , (d) -> y d[1])
      .attr("width" , barWidth)
      .attr("height", (d) -> y(0) - y(d[1]))
      .style("fill" , (d) -> "#f54")

    year.selectAll(".loss")
      .data((d) -> [d])
      .enter()
      .append("rect")
      .attr("class" , "loss")
      .attr("x"     , barX)
      .attr("y"     , (d) -> y d[1] + d[2])
      .attr("width" , barWidth)
      .attr("height", (d) -> y(d[1]) - y(d[1] + d[2]) - 1)
      .style("fill" , (d) -> "#495")

    # Win percentage
    year.selectAll(".percentage")
      .data((d) -> [d])
      .enter()
      .append("circle")
      .attr("class", "percentage")
      .attr("r"    , 3)
      .attr("cx"   , (d, i) -> 35)
      .attr("cy"   , (d) -> y 50 + 100 * d[1] / (d[1] + d[2]))
      .style("fill", (d) -> "#65d")

    year.append("text")
      .text((d) -> d3.format("%d") d[1] / (d[1] + d[2]))
      .attr("x", (d, i) -> 20)
      .attr("y", (d) -> y(50 + 100 * d[1] / (d[1] + d[2])) - 10)
    
    # Win percentage line
    x1 = d3.scale.linear()
      .domain([0, data.length])
      .range([8, width])

    y1 = d3.scale.linear()
      .domain([0, 150])
      .range([height, 0])

    line = d3.svg.line()
      .x((d, i) -> x1(i) + 35)
      .y((d) -> y 50 + 100 * d[1] / (d[1] + d[2]))

    lines = svg.append("g")
      .attr("class", "line")
      .append("path")
      .datum(data)
      .attr("d", line)

