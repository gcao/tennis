FIRST_YEAR = 2003
THIS_YEAR  = new Date().getYear() + 1900
YEARS      = [FIRST_YEAR..THIS_YEAR]

T.def 'rank-history', (fromYear, toYear) ->
  [
    [ 'h2'
      'ATP rank history'
      [ 'span.generated-note'
        ' (generated at '
        [ 'span.generated-at' ]
        ' )'
      ]
    ]
    ['#rank-history', ['svg']]
    [ '#timespan'
      'Time span: '
      [ 'select'
        name: 'fromYear'
        #change: ->
        #  fromYear = $(this).val()
        #  toYear   = $("[name = toYear]").val()
        #  $("[name=toYear]").html ""
        #  year = parseInt(fromYear)

        #  while year <= THIS_YEAR
        #    $("[name=toYear]").append "<option>" + year + "</option>"
        #    year++

        #  $("[name=toYear]").val (if toYear then toYear else THIS_YEAR)

        renderComplete: (el) -> $(el).val(fromYear)

        for year in YEARS
          ['option', year]
      ]
      ' - '
      [ 'select'
        name: 'toYear'
        renderComplete: (el) -> $(el).val(toYear)

        for year in YEARS
          ['option', year]
      ]
      [ 'button.update', 
        click: ->
          players  = (el.value for el in $("[name=player]:checked"))
          fromYear = $("[name=fromYear]").val()
          toYear   = $("[name=toYear]").val()

          if players.length is 0
            alert "No player is selected."
          else
            window.location.hash = "#/rank-history/#{players.join(',')}?fromYear=#{fromYear}&toYear=#{toYear}"

        'Update graph'
      ]
    ]
    ['#players']
  ]

T.def 'player-field', (player, index) ->
  return  if index >= 50

  name = player.first + " " + player.last
  value = (player.first + "_" + player.last).toLowerCase().replace(/[ -]/g, "_")
  [
    [ 'div.player'
      [ 'input'
        type: 'checkbox'
        name: 'player'
        value: value
      ]
      ['div', name]
    ]
    ['br'] if index % 5 is 4
  ]

loadAndShowRankHistory = (players, fromYear, toYear) ->
  if players.length is 0
    alert "No player is chosen!"
    return

  loadRankHistory(players).then ->
    results = if arguments[0] instanceof Array then arguments else [arguments]
    data = $.map(results, (request) -> request[0])
    showRankHistory data, fromYear, toYear

loadRankHistory = (players) ->
  $.when ($.map(players, (player) -> loadData player + "_rank_history"))...

showRankHistory = (data, fromYear, toYear) ->
  data = $.map data, (e) ->
    hist = filterHistoryData(e.history, fromYear, toYear)
    key: e.first + " " + e.last
    values: hist

  nv.addGraph ->
    chart = nv.models.lineChart()
      .x((d) -> Date.parse d[0])
      .y((d) -> 50 - d[1])
      .margin(left: 20, right: 40)
      .color(d3.scale.category10().range())
    chart.xAxis.rotateLabels(30)
      .tickValues( do -> $.map THIS_YEAR, (year) -> Date.parse "1/1/" + year)
      .tickFormat((d) -> d3.time.format("%x")(new Date(d)))

    chart.yAxis.tickValues([0, 10, 20, 30, 40, 45, 46, 47, 48, 49])
      .showMaxMin(false)
      .tickFormat((d) -> 50 - d)

    d3.select("#rank-history svg").datum(data).transition().duration(500).call chart
    nv.utils.windowResize chart.update
    chart

filterHistoryData = (data, fromYear, toYear) ->
  fromTime = Date.parse(fromYear + "/1/1")
  toTime = Date.parse(parseInt(toYear) + 1 + "/1/1")
  $.map data, (item) ->
    time = Date.parse(item[0])
    [item]  if time >= fromTime and time < toTime

router.get '/rank-history/:players', (req) ->
  players  = req.params.players.split(',')
  fromYear = req.params.fromYear || FIRST_YEAR
  toYear   = req.params.toYear   || THIS_YEAR

  T('rank-history', fromYear, toYear).render inside: '.main'

  loadData "rankings", (rankings) ->
    updateGenerationTime rankings.generated_at

    T.each_with_index('player-field', rankings.data).render inside: '#players'

    for player in players
      $("[value=#{player}]").attr('checked', 'checked')

    loadAndShowRankHistory players, fromYear, toYear
