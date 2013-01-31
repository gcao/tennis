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

window.loadData = (id, successHandler) ->
  if useLocalData
    $.getJSON "data/" + id + ".json", successHandler
  else
    $.getJSON "http://gcao.cloudant.com/tennis/" + id + "?callback=?", successHandler

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
        new google.maps.MarkerImage("images/ao_logo.png")
      else if tournamentName.match(/roland garros/i)
        new google.maps.MarkerImage("images/fo_logo.png")
      else if tournamentName.match(/wimbledon/i)
        new google.maps.MarkerImage("images/wo_logo.png")
      else if tournamentName.match(/us open/i)
        new google.maps.MarkerImage("images/uo_logo.png")

window.getTournamentPriority = (tournamentType) ->
  switch tournamentType
    when "atp250"       then 2
    when "atp500"       then 3
    when "atp1000"      then 4
    when "atptourfinal" then 5
    when "grandslam"    then 6
    else 1

window.getInfoWindowContent = (tournament) ->
  """
    <div class="map-info">"
      <p class="tournament-name">
        <a href="http://www.atpworldtour.com#{tournament.url}" target="_new">#{tournament.name}</a>
      </p>
      <p>
        <span class="tournament-time">#{tournament.start}</span>
        @ <span class="tournament-place">#{tournament.place}</span>
      </p>
      <p class="tournament-title-holder">
        Title Holder:
        <a href="http://www.atpworldtour.com#{tournament.title_holder.url}"
        target="_new">#{tournament.title_holder.name}</a>
      </p>
    </div>
  """
