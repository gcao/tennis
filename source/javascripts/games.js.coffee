T.def 'games', (grandSlam, players) ->
  [
    [ 'h2'
      'Games of '
      ['span.players']
    ]
    ['#games-chart']
  ]

valueLabelWidth = 50    #space reserved for value labels (right)
barHeight       = 20    #height of one bar
barLabelWidth   = 107   #space reserved for bar labels
barLabelPadding = 5     #padding between bar and bar labels (left)
gridLabelHeight = 18    #space reserved for gridline labels
gridChartOffset = 3     #space between start of grid and first bar
maxBarWidth     = 920   #width of the bar with the max value
dataLength      = 51
xMax            = 13999 #Avoid draw 14000 vertical grid
duration        = -> (if firstTime then 0 else 3000)
exitDuration    = -> (if firstTime then 0 else 1200)

i2rank          = (i) -> if i < 10 then " _" + i else " " + i

label           = (d, i) -> d.last + i2rank(d.rank)
barLabel        = (d, i) -> d.points

# scales
yScale          = d3.scale.ordinal().domain(d3.range(0, dataLength)).rangeBands([0, dataLength * barHeight])
y               = (d, i) -> yScale i
yText           = (d, i) -> yScale(i) + yScale.rangeBand() / 2
x               = d3.scale.linear().domain([0, xMax]).range([0, maxBarWidth])
xBarLabel       = (d) -> x d.points

initChart = ->
  # svg container element
  chart = d3.select("#rankings-chart")
    .append("svg")
    .attr("width", maxBarWidth + barLabelWidth + valueLabelWidth)
    .attr("height", gridLabelHeight + gridChartOffset + dataLength * barHeight - 20)

  # horizontal grid lines
  hGridContainer = chart.append("g")
  hGridContainer.selectAll("line")
    .data([1, 11, 21, 31, 41])
    .enter()
    .append("line")
    .attr("x1", 0)
    .attr("x2", x(xMax))
    .attr("y1", (d) -> yScale d)
    .attr("y2", (d) -> yScale d)
    .style("stroke", "#ccc")

  # grid line labels
  gridContainer = chart.append("g")
    .attr("transform", "translate(" + barLabelWidth + "," + gridLabelHeight + ")")
  gridContainer.selectAll("text").data(x.ticks(5))
    .enter()
    .append("text")
    .attr("x", x)
    .attr("dy", -3)
    .attr("text-anchor", "middle")
    .text(String)

  # vertical grid lines
  gridContainer.selectAll("line").data(x.ticks(5))
    .enter()
    .append("line")
    .attr("x1", x)
    .attr("x2", x)
    .attr("y1", 0)
    .attr("y2", yScale.rangeExtent()[1] + gridChartOffset)
    .style("stroke", "#ccc")

  # bar labels
  labelsContainer = chart.append("g")
    .attr('id', 'labelsContainer')
    .attr("transform", "translate(" + (barLabelWidth - barLabelPadding) + "," + (gridLabelHeight + gridChartOffset) + ")")

  barsContainer = chart.append("g")
    .attr('id', 'barsContainer')
    .attr("transform", "translate(" + barLabelWidth + "," + (gridLabelHeight + gridChartOffset) + ")")

drawGames = (d) ->
  tournamentContainer = barsContainer.append('div')
    .attr('class', 'tournament')

  for game in d.games
    tournamentContainer.append("rect")
      .attr("height", yScale.rangeBand())
      .attr("width", 120)
      .attr("stroke", "white")
      .attr("fill", "steelblue")
      .attr("x", 0)
      .attr("y", y)

showChart = (data) ->
  labels = d3.select("#labelsContainer").selectAll("text").data(data, (d) -> d.first + d.last)

  labels.enter()
    .append("text")
    .attr("stroke", "none")
    .attr("fill", "black")
    .attr("dy", ".35em") # vertical-align: middle
    .attr("text-anchor", "end")
    .text(label)
    .attr("y", yText)

  barsContainer = d3.select("#barsContainer")

  bars = barsContainer.selectAll(".tournament").data(data)

  bars.enter()
    .call(drawGames)

  #barLabels = barsContainer.selectAll("text").data(data, (d) -> d.first + d.last)

  #barLabels.enter()
  #  .append("text")
  #  .attr("x", xBarLabel)
  #  .attr("dx", 3)# padding-left
  #  .attr("dy", ".35em")# vertical-align: middle
  #  .attr("text-anchor", "start")# text-align: right
  #  .attr("fill", "black")
  #  .attr("stroke", "none")
  #  .text(barLabel)
  #  .attr("y", yText)

  firstTime = false

loadDataAndShowChart = (player) ->
  loadData "#{player}_games", (result) ->
    showChart result.data

router.get '/games/:player', (req) ->
  loadDataAndShowChart(req.params.player)

