T.def 'rank-history', ->
  [
    [ 'h2'
      'ATP rank history'
      [ 'span.generated-note'
        ' (generated at '
        [ 'span.generated-at' ]
        ')'
      ]
    ]
    ['#rank-history', ['svg']]
    [ '#timespan'
      'Time span: '
      ['select', name: 'fromYear']
      ' - '
      ['select', name: 'toYear']
      [ 'button.update', 
        click: ->
          players = $("[name=player]:checked").map(-> @value)
          if players.length is 0
            alert "No player is selected."
          else if players.length is 1
            window.location.hash = "#/ranking-history?players=" + players[0]
          else
            s = players[0]
            i = 1

            while i < players.length
              s += "," + players[i]
              i++

            window.location.hash = "#/ranking-history?players=" + s + "&fromYear=" + $("[name=fromYear]").val() + "&toYear=" + $("[name=toYear]").val()
        'Update graph'
      ]
    ]
    ['#players']
  ]

window.loadAndShowRankHistory = (players, fromYear, toYear) ->
  if players.length is 0
    alert "No player is chosen!"
    return

  loadRankHistory(players).then ->
    results = if arguments[0] instanceof Array then arguments else [arguments]
    data = $.map(results, (request) -> request[0])
    showRankHistory data, fromYear, toYear

window.loadRankHistory = (players) ->
  $.when ($.map(players, (player) -> loadData player + "_rank_history"))...

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

router.get '/rank-history/:players', (req) ->
  console.log 'rank-history'

  T('rank-history').render inside: '.main'

  loadData "rankings", (rankings) ->
    updateGenerationTime rankings.generated_at

    $("[name=fromYear]").change changeFromYear

    $.each rankings.data, (i, r) ->
      return  if i >= 50
      name = r.first + " " + r.last
      value = (r.first + "_" + r.last).toLowerCase().replace(/[ -]/g, "_")
      $("#players").append "<div class=\"player\"><input type=\"checkbox\" name=\"player\" value=\"" + value + "\"><span>" + name + "</span></div>"
      $('#players').append('<br/>') if i % 5 is 4


    fromYear = 2003
    fromYearParam = getQueryVar("fromYear")
    fromYear = parseInt(fromYearParam)  if fromYearParam
    initFromYear()
    $("[name=fromYear]").val fromYear

    toYear = getYear()
    toYearParam = getQueryVar("toYear")
    toYear = parseInt(toYearParam)  if toYearParam
    initToYear fromYear
    $("[name=toYear]").val toYear

    players = req.params.players.split(',')
    $.each players, (i, p) ->
      $("[value=" + p + "]").click()

    loadAndShowRankHistory players, fromYear, toYear
