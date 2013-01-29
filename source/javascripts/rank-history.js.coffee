window.loadAndShowRankHistory = (players, fromYear, toYear) ->
  if players.length is 0
    alert "No player is chosen!"
    return

  loadRankHistory(players).then ->
    data = $.map(arguments, (request) -> request[0])
    showRankHistory data, fromYear, toYear

window.loadRankHistory = (players) ->
  $.when.apply $, $.map(players, (player) -> loadData player + "_rank_history")

window.showRankHistory = (data, fromYear, toYear) ->
  data = $.map(data, (e) ->
    hist = filterHistoryData(e.history, fromYear, toYear)
    key: e.first + " " + e.last
    values: hist
  )
  nv.addGraph ->
    chart = nv.models.lineChart()
      .x((d) -> Date.parse d[0])
      .y((d) -> 50 - d[1])
      .margin(left: 20, right: 40)
      .color(d3.scale.category10().range())
    chart.xAxis.rotateLabels(30)
      .tickValues( do -> $.map getYears(), (year) -> Date.parse "1/1/" + year)
      .tickFormat((d) -> d3.time.format("%x")(new Date(d)))

    chart.yAxis.tickValues([0, 10, 20, 30, 40, 45, 46, 47, 48, 49])
      .showMaxMin(false)
      .tickFormat((d) -> 50 - d)

    d3.select("#rank-history svg").datum(data).transition().duration(500).call chart
    nv.utils.windowResize chart.update
    window.chart = chart
    chart

window.getYear = ->
  new Date().getYear() + 1900

window.getYears = ->
  years = []
  year = 2003
  while year <= getYear()
    years[year - 2003] = year
    year++
  years

window.filterHistoryData = (data, fromYear, toYear) ->
  fromTime = Date.parse(fromYear + "/1/1")
  toTime = Date.parse(parseInt(toYear) + 1 + "/1/1")
  $.map data, (item) ->
    time = Date.parse(item[0])
    [item]  if time >= fromTime and time < toTime

window.initFromYear = ->
  $("[name=fromYear]").html ""
  year = 2003

  while year <= getYear()
    $("[name=fromYear]").append "<option>" + year + "</option>"
    year++

window.initToYear = (fromYear) ->
  $("[name=toYear]").html ""
  year = fromYear

  while year <= getYear()
    $("[name=toYear]").append "<option>" + year + "</option>"
    year++

window.changeFromYear = ->
  fromYear = $("[name = fromYear]").val()
  toYear   = $("[name = toYear]").val()
  $("[name=toYear]").html ""
  year = parseInt(fromYear)

  while year <= getYear()
    $("[name=toYear]").append "<option>" + year + "</option>"
    year++

  $("[name=toYear]").val (if toYear then toYear else getYear())


