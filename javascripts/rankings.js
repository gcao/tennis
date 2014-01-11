(function(){var e,t,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S;tmpl.rankings=function(e){return[["h2","ATP rankings chart for top 50 players",["span.generated-note"," (generated at ",["span.generated-at"]," )"]],["form#rankings-form",{action:"#/rankings",method:"get"},["input#ytd",{type:"checkbox",name:"ytd",value:"true",click:function(){var e;return e="#/rankings",$(this).is(":checked")&&(e+="?ytd"),window.location.hash=e},postRender:function(t){if(e)return $(t).attr("checked","checked")}}],["label",{"for":"ytd"},"Year To Date &nbsp;"]],["#rankings-chart",{style:"height: 1000px"}]]},u=!0,m=50,e=20,r=107,n=5,f=18,a=3,d=920,i=51,b=13999,s=function(){return u?0:3e3},o=function(){return u?0:1200},l=function(e){return e<10?" _"+e:" "+e},h=function(e,t){return e.last+l(e.rank)},t=function(e,t){return e.points},E=d3.scale.ordinal().domain(d3.range(0,i)).rangeBands([0,i*e]),w=function(e,t){return E(t)},S=function(e,t){return E(t)+E.rangeBand()/2},g=d3.scale.linear().domain([0,b]).range([0,d]),y=function(e){return g(e.points)},c=function(){var t,s,o,u,l;return s=d3.select("#rankings-chart").append("svg").attr("width",d+r+m).attr("height",f+a+i*e-20),u=s.append("g"),u.selectAll("line").data([1,11,21,31,41]).enter().append("line").attr("x1",0).attr("x2",g(b)).attr("y1",function(e){return E(e)}).attr("y2",function(e){return E(e)}).style("stroke","#ccc"),o=s.append("g").attr("transform","translate("+r+","+f+")"),o.selectAll("text").data(g.ticks(5)).enter().append("text").attr("x",g).attr("dy",-3).attr("text-anchor","middle").text(String),o.selectAll("line").data(g.ticks(5)).enter().append("line").attr("x1",g).attr("x2",g).attr("y1",0).attr("y2",E.rangeExtent()[1]+a).style("stroke","#ccc"),l=s.append("g").attr("id","labelsContainer").attr("transform","translate("+(r-n)+","+(f+a)+")"),t=s.append("g").attr("id","barsContainer").attr("transform","translate("+r+","+(f+a)+")")},v=function(e){var n,r,o,a;return a=d3.select("#labelsContainer").selectAll("text").data(e,function(e){return e.first+e.last}),a.transition().duration(s).ease("exp-out").attr("y",S).text(h),a.enter().append("text").attr("y",E(i-1)).attr("stroke","none").attr("fill","black").attr("dy",".35em").attr("text-anchor","end").text(h).transition().duration(s).ease("exp-out").attr("y",S),a.exit().remove(),o=d3.select("#barsContainer"),r=o.selectAll("rect").data(e,function(e){return e.first+e.last}),r.transition().duration(s).ease("exp-out").attr("width",function(e){return g(e.points)}).attr("y",w),r.enter().append("rect").attr("y",E(i-1)).attr("height",E.rangeBand()).attr("width",function(e){return g(e.points)}).attr("stroke","white").attr("fill","steelblue").transition().duration(s).ease("exp-out").attr("y",w),r.exit().remove(),n=o.selectAll("text").data(e,function(e){return e.first+e.last}),n.transition().duration(s).ease("exp-out").attr("x",y).attr("y",S).text(t),n.enter().append("text").attr("x",y).attr("y",E(i-1)).attr("dx",3).attr("dy",".35em").attr("text-anchor","start").attr("fill","black").attr("stroke","none").text(t).transition().duration(s).ease("exp-out").attr("y",S),n.exit().remove(),u=!1},p=function(e){var t;return t=e?"rankings_ytd":"rankings",loadData(t,function(e){return updateGenerationTime(e.generated_at),v(e.data)})},router.get("/rankings",function(e){var t;return u=!0,t=e.params.ytd,u&&(T(tmpl.rankings,t).render({inside:".main"}),c()),p(t)})}).call(this);