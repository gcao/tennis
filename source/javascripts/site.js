$(document).ready(function(){
  if (location.pathname.match(/rankings/)) {
    $('li.rankings').addClass('current');
  } else if (location.pathname.match(/rank-history/)) {
    $('li.rank-history').addClass('current');
  } else if (location.pathname.match(/tournaments/)) {
    $('li.tournaments').addClass('current');
  } else if (location.pathname.match(/support/)) {
    $('li.support').addClass('current');
  }
});

function getQueryVar(varName){
  // Grab and unescape the query string - appending an '&' keeps the RegExp simple
  // for the sake of this example.
  var queryStr = unescape(window.location.search) + '&';

  // Dynamic replacement RegExp
  var regex = new RegExp('.*?[&\\?]' + varName + '=(.*?)&.*');

  // Apply RegExp to the query string
  val = queryStr.replace(regex, "$1");

  // If the string is the same, we didn't find a match - return false
  return val == queryStr ? false : val;
}

function updateGenerationTime(time) {
  var date = new Date(time*1000);
  var month = date.getMonth() + 1;
  var day = date.getDate();
  var year = date.getYear() + 1900;
  $('.generated-at').text(month + '/' + day + '/' + year);
}

function loadAndShowRankHistory(players, fromYear, toYear) {
  if (players.length == 0) {
    alert('No player is chosen!');
    return;
  }

  loadRankHistory(players).then(function(){
    var data = $.map(arguments, function(request){ return request[0] });
    showRankHistory(data, fromYear, toYear);
  });
}

function loadRankHistory(players) {
  return $.when.apply($, $.map(players, function(player) {
    return $.getJSON('/data/' + player + '_rank_history.json');
  }));
}

function showRankHistory(data, fromYear, toYear) {
  data = $.map(data, function(e) {
    var hist = filterHistoryData(e.history, fromYear, toYear);
    return {key: e.first + ' ' + e.last, values: hist};
  });

  nv.addGraph(function() {
    var chart = nv.models.lineChart()
                  .x(function(d) { return Date.parse(d[0]) })
                  .y(function(d) { return 50 - d[1] })
                  .margin({left: 20, right: 40})
                  .color(d3.scale.category10().range());

    chart.xAxis
         .rotateLabels(30)
         .tickValues(function(){
           return $.map(getYears(), function(year) {
             return Date.parse('1/1/' + year);
           });
         }())
         .tickFormat(function(d) {
           return d3.time.format('%x')(new Date(d));
         });

    chart.yAxis
         .tickValues([0, 10, 20, 30, 40, 45, 46, 47, 48, 49])
         .showMaxMin(false)
         .tickFormat(function(d) {
           return 50-d;
         });

    d3.select('#rank-history svg')
      .datum(data)
      .transition().duration(500)
      .call(chart);

    nv.utils.windowResize(chart.update);

    window.chart = chart;
    return chart;
  });
}

function getYear() {
  return new Date().getYear() + 1900;
}

function getYears() {
  var years = [];
  for (year = 2003; year <= getYear(); year++) {
    years[year - 2003] = year;
  }
  return years;
}

function filterHistoryData(data, fromYear, toYear) {
  var fromTime = Date.parse(fromYear + '/1/1');
  var toTime = Date.parse(parseInt(toYear) + 1 + '/1/1');
  return $.map(data, function(item) {
    var time = Date.parse(item[0]);
    if (time >= fromTime && time < toTime) return [item];
  });
}

function initFromYear() {
  $('[name=fromYear]').html('');
  for (var year=2003; year<=getYear(); year++) {
    $('[name=fromYear]').append('<option>' + year + '</option>');
  }
}
function initToYear(fromYear) {
  $('[name=toYear]').html('');
  for (var year=fromYear; year<=getYear(); year++) {
    $('[name=toYear]').append('<option>' + year + '</option>');
  }
}

function changeFromYear() {
  var fromYear = $('[name=fromYear]').val();
  var toYear = $('[name=toYear]').val();
  $('[name=toYear]').html('');
  for (var year = parseInt(fromYear); year <= getYear(); year++) {
    $('[name=toYear]').append('<option>' + year + '</option>');
  }
  $('[name=toYear]').val(toYear ? toYear : getYear());
}

