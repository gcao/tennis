(function(){window.getAtpUrl=function(e){return"http://www.atpworldtour.com"+e},window.getQueryVar=function(e){var t,n,r;return t=unescape(window.location.search)+"&",n=new RegExp(".*?[&\\?]"+e+"=(.*?)&.*"),r=t.replace(n,"$1"),r===t?!1:r},window.loadData=function(e,t){return useLocalData?$.getJSON("data/"+e+".json",t):$.getJSON("http://gcao.cloudant.com/tennis/"+e+"?callback=?",t)},window.updateGenerationTime=function(e){var t,n,r,i;return t=new Date(e*1e3),r=t.getMonth()+1,n=t.getDate(),i=t.getYear()+1900,$(".generated-at").text(r+"/"+n+"/"+i)},window.getMap=function(){return new google.maps.Map(document.getElementById("map"),{zoom:3,center:new google.maps.LatLng(25,0),mapTypeId:google.maps.MapTypeId.ROADMAP})},window.getTournamentLogo=function(e,t){switch(e){case"atp250":return"http://www.atpworldtour.com/~/media/810218DC73784BEEA6EF0978B2842A69.ashx?w=31&h=36";case"atp500":return"http://www.atpworldtour.com/~/media/1DB04CA8505648B7B511FA1E37F1E3BA.ashx?w=31&h=36";case"atp1000":return"http://www.atpworldtour.com/~/media/F5219431817E4ED3B773BF9B006A9ACF.ashx?w=31&h=42";case"atptourfinal":return"http://www.atpworldtour.com/~/media/47F12472FD254B08B57755E5B7565E5D.ashx?w=31&h=48";case"grandslam":if(t.match(/australian open/i))return"images/ao_logo.png";if(t.match(/roland garros/i))return"images/fo_logo.png";if(t.match(/wimbledon/i))return"images/wo_logo.png";if(t.match(/us open/i))return"images/uo_logo.png"}},window.getTournamentPriority=function(e){switch(e){case"atp250":return 2;case"atp500":return 3;case"atp1000":return 4;case"atptourfinal":return 5;case"grandslam":return 6;default:return 1}},window.getInfoWindowContent=function(e){return'<div class="map-info">\n  <p class="tournament-name">\n    <a href="http://www.atpworldtour.com'+e.url+'" target="_new">'+e.name+'</a>\n  </p>\n  <p>\n    <span class="tournament-time">'+e.start+'</span>\n    @ <span class="tournament-place">'+e.place+"</span>\n  </p>\n</div>"},window.formatDate=function(e,t){return t==null&&(t="YYYY-MM-DD"),t=t.replace("DD",(e.getDate()<10?"0":"")+e.getDate()),t=t.replace("MM",(e.getMonth()<9?"0":"")+(e.getMonth()+1)),t.replace("YYYY",e.getFullYear())},window.isFuture=function(e){return e>formatDate(new Date)}}).call(this);