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

