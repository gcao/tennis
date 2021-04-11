(function(){var e,t,n,r,i,s,o,u,a;e=2003,t=(new Date).getYear()+1900,n=function(){a=[];for(var n=e;e<=t?n<=t:n>=t;e<=t?n++:n--)a.push(n);return a}.apply(this),tmpl.rankHistory=function(e,t){var r;return[["h2","ATP rank history",["span.generated-note"," (generated at ",["span.generated-at"]," )"]],["#rank-history",["svg"]],["#timespan","Time span: ",["select",{name:"fromYear",postRender:function(t){return $(t).val(e)}},function(){var e,t,i;i=[];for(e=0,t=n.length;e<t;e++)r=n[e],i.push(["option",r]);return i}()]," - ",["select",{name:"toYear",postRender:function(e){return $(e).val(t)}},function(){var e,t,i;i=[];for(e=0,t=n.length;e<t;e++)r=n[e],i.push(["option",r]);return i}()],["button.update",{click:function(){var n,r;return r=function(){var e,t,r,i;r=$("[name=player]:checked"),i=[];for(e=0,t=r.length;e<t;e++)n=r[e],i.push(n.value);return i}(),e=$("[name=fromYear]").val(),t=$("[name=toYear]").val(),r.length===0?alert("No player is selected."):window.location.hash="#/rank-history/"+r.join(",")+"?fromYear="+e+"&toYear="+t}},"Update graph"]],["#players"]]},tmpl.playerField=function(e,t){var n,r;if(t>=50)return;return n=e.first+" "+e.last,r=(e.first+"_"+e.last).toLowerCase().replace(/[ -]/g,"_"),[["div.player",["input",{type:"checkbox",name:"player",value:r}],["div",n]],t%5===4?["br"]:void 0]},i=function(e,t,n){if(e.length===0){alert("No player is chosen!");return}return s(e).then(function(){var e,r;return r=arguments[0]instanceof Array?arguments:[arguments],e=$.map(r,function(e){return e[0]}),o(e,t,n)})},s=function(e){return $.when.apply($,$.map(e,function(e){return loadData(e+"_rank_history")}))},o=function(e,n,i){return e=$.map(e,function(e){var t;return t=r(e.history,n,i),{key:e.first+" "+e.last,values:t}}),nv.addGraph(function(){var n;return n=nv.models.lineChart().x(function(e){return Date.parse(e[0])}).y(function(e){return 50-e[1]}).margin({left:20,right:40}).color(d3.scale.category10().range()),n.xAxis.rotateLabels(30).tickValues(function(){return $.map(t,function(e){return Date.parse("1/1/"+e)})}()).tickFormat(function(e){return d3.time.format("%x")(new Date(e))}),n.yAxis.tickValues([0,10,20,30,40,45,46,47,48,49]).showMaxMin(!1).tickFormat(function(e){return 50-e}),d3.select("#rank-history svg").datum(e).transition().duration(500).call(n),nv.utils.windowResize(n.update),n})},r=function(e,t,n){var r,i;return r=Date.parse(t+"/1/1"),i=Date.parse(parseInt(n)+1+"/1/1"),$.map(e,function(e){var t;t=Date.parse(e[0]);if(t>=r&&t<i)return[e]})},router.get("/rank-history/:players",function(n){var r,s,o;return s=n.params.players.split(","),r=n.params.fromYear||e,o=n.params.toYear||t,T(tmpl.rankHistory,r,o).render({inside:".main"}),loadData("rankings",function(e){var t,n,u;updateGenerationTime(e.generated_at),T.eachWithIndex(tmpl.playerField,e.data).render({inside:"#players"});for(n=0,u=s.length;n<u;n++)t=s[n],$("[value="+t+"]").attr("checked","checked");return i(s,r,o)})})}).call(this);