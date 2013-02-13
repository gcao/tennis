(function(){window.getAtpUrl=function(e){return"http://www.atpworldtour.com"+e},window.getQueryVar=function(e){var t,n,r;return t=unescape(window.location.search)+"&",n=new RegExp(".*?[&\\?]"+e+"=(.*?)&.*"),r=t.replace(n,"$1"),r===t?!1:r},window.DEFAULT_PLAYERS=["novak_djokovic","roger_federer","andy_murray","rafael_nadal"],window.getPlayers=function(e){var t,n;return t=null,n=getQueryVar("players"),n&&n!==""?t=n.split(","):t=e},window.loadData=function(e,t){return useLocalData||getQueryVar("local_data")==="true"?$.getJSON("data/"+e+".json",t):$.getJSON("http://gcao.cloudant.com/tennis/"+e+"?callback=?",t)},window.loadData2=function(e){var t;return t=function(e){return useLocalData||getQueryVar("local_data")==="true"?"data/"+e+".json":"http://gcao.cloudant.com/tennis/"+e+"?callback=?"},$.when.apply($,$.map(e,function(e){return $.getJSON(t(e))}))},window.normalizeResults=function(e){var t,n,r,i;if(e[1]instanceof Array){i=[];for(n=0,r=e.length;n<r;n++)t=e[n],i.push(t[0]);return i}return[e[0]]},window.updateGenerationTime=function(e){var t,n,r,i;return t=new Date(e*1e3),r=t.getMonth()+1,n=t.getDate(),i=t.getYear()+1900,$(".generated-at").text(r+"/"+n+"/"+i)},window.getMap=function(){return new google.maps.Map(document.getElementById("map"),{zoom:3,center:new google.maps.LatLng(25,0),mapTypeId:google.maps.MapTypeId.ROADMAP})},window.getTournamentLogo=function(e,t){switch(e){case"atp250":return"http://www.atpworldtour.com/~/media/810218DC73784BEEA6EF0978B2842A69.ashx?w=31&h=36";case"atp500":return"http://www.atpworldtour.com/~/media/1DB04CA8505648B7B511FA1E37F1E3BA.ashx?w=31&h=36";case"atp1000":return"http://www.atpworldtour.com/~/media/F5219431817E4ED3B773BF9B006A9ACF.ashx?w=31&h=42";case"atptourfinal":return"http://www.atpworldtour.com/~/media/47F12472FD254B08B57755E5B7565E5D.ashx?w=31&h=48";case"grandslam":if(t.match(/australian open/i))return"images/ao_logo.png";if(t.match(/roland garros/i))return"images/fo_logo.png";if(t.match(/wimbledon/i))return"images/wo_logo.png";if(t.match(/us open/i))return"images/uo_logo.png"}},window.getTournamentPriority=function(e){switch(e){case"atp250":return 2;case"atp500":return 3;case"atp1000":return 4;case"atptourfinal":return 5;case"grandslam":return 6;default:return 1}},window.getInfoWindowContent=function(e){return'<div class="map-info">\n  <p class="tournament-name">\n    <a href="http://www.atpworldtour.com'+e.url+'" target="_new">'+e.name+'</a>\n  </p>\n  <p>\n    <span class="tournament-time">'+e.start+'</span>\n    @ <span class="tournament-place">'+e.place+"</span>\n  </p>\n</div>"},window.formatDate=function(e,t){return t==null&&(t="YYYY-MM-DD"),t=t.replace("DD",(e.getDate()<10?"0":"")+e.getDate()),t=t.replace("MM",(e.getMonth()<9?"0":"")+(e.getMonth()+1)),t.replace("YYYY",e.getFullYear())},window.isFuture=function(e){return e>formatDate(new Date)}}).call(this),function(){window.loadAndShowRankHistory=function(e,t,n){if(e.length===0){alert("No player is chosen!");return}return loadRankHistory(e).then(function(){var e,r;return r=arguments[0]instanceof Array?arguments:[arguments],e=$.map(r,function(e){return e[0]}),showRankHistory(e,t,n)})},window.loadRankHistory=function(e){return $.when.apply($,$.map(e,function(e){return loadData(e+"_rank_history")}))},window.showRankHistory=function(e,t,n){return e=$.map(e,function(e){var r;return r=filterHistoryData(e.history,t,n),{key:e.first+" "+e.last,values:r}}),nv.addGraph(function(){var t;return t=nv.models.lineChart().x(function(e){return Date.parse(e[0])}).y(function(e){return 50-e[1]}).margin({left:20,right:40}).color(d3.scale.category10().range()),t.xAxis.rotateLabels(30).tickValues(function(){return $.map(getYears(),function(e){return Date.parse("1/1/"+e)})}()).tickFormat(function(e){return d3.time.format("%x")(new Date(e))}),t.yAxis.tickValues([0,10,20,30,40,45,46,47,48,49]).showMaxMin(!1).tickFormat(function(e){return 50-e}),d3.select("#rank-history svg").datum(e).transition().duration(500).call(t),nv.utils.windowResize(t.update),window.chart=t,t})},window.getYear=function(){return(new Date).getYear()+1900},window.getYears=function(){var e,t;t=[],e=2003;while(e<=getYear())t[e-2003]=e,e++;return t},window.filterHistoryData=function(e,t,n){var r,i;return r=Date.parse(t+"/1/1"),i=Date.parse(parseInt(n)+1+"/1/1"),$.map(e,function(e){var t;t=Date.parse(e[0]);if(t>=r&&t<i)return[e]})},window.initFromYear=function(){var e,t;$("[name=fromYear]").html(""),e=2003,t=[];while(e<=getYear())$("[name=fromYear]").append("<option>"+e+"</option>"),t.push(e++);return t},window.initToYear=function(e){var t,n;$("[name=toYear]").html(""),t=e,n=[];while(t<=getYear())$("[name=toYear]").append("<option>"+t+"</option>"),n.push(t++);return n},window.changeFromYear=function(){var e,t,n;e=$("[name = fromYear]").val(),t=$("[name = toYear]").val(),$("[name=toYear]").html(""),n=parseInt(e);while(n<=getYear())$("[name=toYear]").append("<option>"+n+"</option>"),n++;return $("[name=toYear]").val(t?t:getYear())}}.call(this),function(){}.call(this);