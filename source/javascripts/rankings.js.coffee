T.def 'rankings', (ytd) ->
  [
    [ 'h2'
      'ATP rankings chart for top 50 players'
      [ 'span.generated-note'
        ' (generated at '
        [ 'span.generated-at' ]
        ' )'
      ]
    ]
    [ 'form#rankings-form'
      action: "#/rankings"
      method: "get"
      [ "input#ytd"
        type: "checkbox"
        name: "ytd"
        value: "true"
        click: ->
          route = "#/rankings"
          if $(this).is(':checked') then route += '?ytd'
          window.location.hash = route
        renderComplete: (el) ->
          if ytd
            $(el).attr('checked', 'checked')
      ]
      [ 'label'
        for: "ytd"
        "Year To Date &nbsp;"
      ]
    ]

    [ "#rankings-chart", style: 'height: 1000px' ]
  ]

# http://d3-generator.com/

firstTime       = true
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

showChart = (data) ->
  labels = d3.select("#labelsContainer").selectAll("text").data(data, (d) -> d.first + d.last)

  # Update transitions
  labels.transition()
    .duration(duration)
    .ease("exp-out")
    .attr("y", yText)
    .text(label)
  labels.enter()
    .append("text")
    .attr("y", yScale(dataLength - 1))
    .attr("stroke", "none")
    .attr("fill", "black")
    .attr("dy", ".35em") # vertical-align: middle
    .attr("text-anchor", "end")
    .text(label)
    .transition()
    .duration(duration)
    .ease("exp-out")
    .attr("y", yText)
  labels.exit()
    .remove()

  barsContainer = d3.select("#barsContainer")

  bars = barsContainer.selectAll("rect").data(data, (d) -> d.first + d.last)

  # Update transitions
  bars.transition()
    .duration(duration)
    .ease("exp-out")
    .attr("width", (d) -> x d
    .points).attr("y", y)
  bars.enter()
    .append("rect")
    .attr("y", yScale(dataLength - 1))
    .attr("height", yScale.rangeBand())
    .attr("width", (d) -> x d.points)
    .attr("stroke", "white")
    .attr("fill", "steelblue")
    .transition()
    .duration(duration)
    .ease("exp-out")
    .attr("y", y)
  bars.exit()
    .remove()

  barLabels = barsContainer.selectAll("text").data(data, (d) -> d.first + d.last)

  # Update transitions
  barLabels.transition()
    .duration(duration)
    .ease("exp-out")
    .attr("x", xBarLabel)
    .attr("y", yText)
    .text(barLabel)
  barLabels.enter()
    .append("text")
    .attr("x", xBarLabel)
    .attr("y", yScale(dataLength - 1))
    .attr("dx", 3)# padding-left
    .attr("dy", ".35em")# vertical-align: middle
    .attr("text-anchor", "start")# text-align: right
    .attr("fill", "black")
    .attr("stroke", "none")
    .text(barLabel)
    .transition()
    .duration(duration)
    .ease("exp-out")
    .attr("y", yText)
  barLabels.exit()
    .remove()

  firstTime = false

loadDataAndShowChart = (ytd) ->
  resource = if ytd then "rankings_ytd" else "rankings"
  loadData resource, (rankings) ->
    updateGenerationTime(rankings.generated_at)
    showChart rankings.data

router.get '/rankings', (req) ->
  firstTime = true
  ytd = req.params.ytd

  if firstTime
    T('rankings', ytd).render inside: '.main'
    initChart()

  loadDataAndShowChart ytd

