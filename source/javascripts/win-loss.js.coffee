#= require vendor/d3.v2.min

players = getQueryVar('players') or 'roger_federer'
d3.json "data/#{players}_win_loss.json", (resp) ->
  data   = resp.data
  margin =
    top    : 20
    right  : 100
    bottom : 30
    left   : 40

  width  = 960 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1)
    .domain(data.map((d) -> d[0]))

  y = d3.scale.linear()
    .rangeRound([height, 0])
    .domain([0, 150])

  xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom")

  yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .tickValues([0, 20, 40, 60, 80, 100])
    .tickFormat(d3.format("d%"))

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

  svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)

  year = svg.selectAll(".year")
    .data(data)
    .enter()
    .append("g")
    .attr("class"    , "year")
    .attr("transform", (d) -> "translate(" + x(d[0]) + ", 0)")

  year.selectAll(".win")
    .data((d) -> [d])
    .enter()
    .append("rect")
    .attr("class" , "win")
    .attr("width" , x.rangeBand())
    .attr("height", (d) -> y(0) - y(d[1]))
    .attr("y"     , (d) -> y d[1])
    .style("fill" , (d) -> "#f54")

  year.selectAll(".loss")
    .data((d) -> [d])
    .enter()
    .append("rect")
    .attr("class" , "loss")
    .attr("width" , x.rangeBand())
    .attr("y"     , (d) -> y d[1] + d[2])
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

