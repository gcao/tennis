$(document).ready(function(){
  if (location.pathname.match(/rankings/)) {
    $('li.rankings').addClass('current');
  } else if (location.pathname.match(/rank-history/)) {
    $('li.rank-history').addClass('current');
  } else if (location.pathname.match(/tournaments/)) {
    $('li.tournaments').addClass('current');
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

function showRankHistory(players) {
  var data = $.map($.map(players, function(player){
    return eval('window.' + player + '_rank_history');
  }), function(e) {
    return {key: e.first + ' ' + e.last, values: e.history};
  });

  if (data.length == 0) {
    alert('No player is chosen!');
    return;
  }

  nv.addGraph(function() {
    var chart = nv.models.lineChart()
                  .x(function(d) { return Date.parse(d[0]) })
                  .y(function(d) { return 50 - d[1] })
                  .color(d3.scale.category10().range());

    chart.xAxis
         .rotateLabels(30)
         .tickValues(function(){
           return $.map([2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013], function(year) {
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

