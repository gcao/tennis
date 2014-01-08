window.router = new routes()

window.tmpl = {}

window.getAtpUrl = (url) ->
  "http://www.atpworldtour.com#{url}"

window.getQueryVar = (varName) ->
  # Grab and unescape the query string - appending an '&' keeps the RegExp simple
  # for the sake of this example.
  queryStr = unescape(window.location.search) + "&"

  # Dynamic replacement RegExp
  regex = new RegExp(".*?[&\\?]" + varName + "=(.*?)&.*")

  # Apply RegExp to the query string
  val = queryStr.replace(regex, "$1")

  # If the string is the same, we didn't find a match - return false
  (if val is queryStr then false else val)

window.DEFAULT_PLAYERS = ['novak_djokovic', 'roger_federer', 'andy_murray', 'rafael_nadal']

window.getPlayers = (defaultPlayers) ->
  players = null
  playersParam = getQueryVar("players")
  if playersParam and playersParam isnt ""
    players = playersParam.split(",")
  else
    players = defaultPlayers

window.loadData = (id, successHandler) ->
  if useLocalData or getQueryVar('local_data') is 'true'
    $.getJSON "data/" + id + ".json", successHandler
  else
    $.getJSON "http://gcao.cloudant.com/tennis/" + id + "?callback=?", successHandler

window.loadData2 = (ids) ->
  toUrl = (id) ->
    if useLocalData or getQueryVar('local_data') is 'true'
      "data/" + id + ".json"
    else
      "http://gcao.cloudant.com/tennis/" + id + "?callback=?"

  $.when ($.map(ids, (id) -> $.getJSON(toUrl(id))))...

window.normalizeResults = (results) ->
  if results[1] instanceof Array
    (result[0] for result in results)
  else
    [results[0]]

window.updateGenerationTime = (time) ->
  date  = new Date(time * 1000)
  month = date.getMonth() + 1
  day   = date.getDate()
  year  = date.getYear() + 1900
  $(".generated-at").text month + "/" + day + "/" + year

window.getMap = ->
  new google.maps.Map(document.getElementById("map"),
    zoom: 3
    center: new google.maps.LatLng(25, 0)
    mapTypeId: google.maps.MapTypeId.ROADMAP
  )

window.getTournamentLogo = (tournamentType, tournamentName) ->
  switch tournamentType
    when "atp250"
      "http://www.atpworldtour.com/~/media/810218DC73784BEEA6EF0978B2842A69.ashx?w=31&h=36"
    when "atp500"
      "http://www.atpworldtour.com/~/media/1DB04CA8505648B7B511FA1E37F1E3BA.ashx?w=31&h=36"
    when "atp1000"
      "http://www.atpworldtour.com/~/media/F5219431817E4ED3B773BF9B006A9ACF.ashx?w=31&h=42"
    when "atptourfinal"
      "http://www.atpworldtour.com/~/media/47F12472FD254B08B57755E5B7565E5D.ashx?w=31&h=48"
    when "grandslam"
      if tournamentName.match(/australian open/i)
        #new google.maps.MarkerImage("images/ao_logo.png")
        "images/ao_logo.png"
      else if tournamentName.match(/roland garros/i)
        "images/fo_logo.png"
      else if tournamentName.match(/wimbledon/i)
        "images/wo_logo.png"
      else if tournamentName.match(/us open/i)
        "images/uo_logo.png"

window.getTournamentPriority = (tournamentType) ->
  switch tournamentType
    when "atp250"       then 2
    when "atp500"       then 3
    when "atp1000"      then 4
    when "atptourfinal" then 5
    when "grandslam"    then 6
    else 1

tmpl.tournamentInfoWindow = (tournament) ->
  [ "div.map-info"
    [ "p.tournament-name"
      [ "a"
        href: "http://www.atpworldtour.com#{tournament.url}"
        target: "_new"
        tournament.name
      ]
      '&nbsp;&nbsp;'
      T('buy-ticket-link', tournament, getTicketUrl(tournament.name))
    ]
    ["p.tournament-time", tournament.start]
    ["p.tournament-place", tournament.place]
  ]

window.formatDate = (date, format = 'YYYY-MM-DD') ->
  format = format.replace("DD",
    (if date.getDate() < 10 then '0' else '') + date.getDate()) # Pad with '0' if needed
  format = format.replace("MM",
    (if date.getMonth() < 9 then '0' else '') + (date.getMonth() + 1)) # Months are zero-based
  format.replace("YYYY", date.getFullYear())

window.isFuture = (formattedDate) ->
  formattedDate > formatDate(new Date())

window.getTicketUrl = (tournamentName) ->
  for item in ticketUrls
    if item.name is tournamentName
      return item.url

tmpl.buyTicketLink = (tournament, url) ->
  return unless tournament and url
  [ 'a.ticket_url'
    href: url
    rel: 'nofollow'
    'Buy&nbsp;Ticket'
  ]
