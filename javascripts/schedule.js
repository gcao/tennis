(function(){var e;e=function(e,t,n,r){var i,s,o,u,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S,x,T,N,C,k,L,A,O,M,_;l=new google.maps.LatLngBounds,x=t.getPosition(),T=n.getPosition(),l.extend(x),l.extend(T),d=new Array,o=Math.PI,k=Math.sin,u=Math.asin,c=Math.cos,a=Math.atan2,C=Math.pow,L=Math.sqrt,v=x.lat()*(o/180),y=x.lng()*(o/180),m=T.lat()*(o/180),b=T.lng()*(o/180),h=2*u(L(C(k((v-m)/2),2)+c(v)*c(m)*C(k((y-b)/2),2))),f=a(k(y-b)*c(m),c(v)*k(m)-k(v)*c(m)*c(y-b))/-(o/180),f=f<0?360+f:f,E=0;while(E<51)p=.02*E,p=p.toFixed(6),i=k((1-p)*h)/k(h),s=k(p*h)/k(h),O=i*c(v)*c(y)+s*c(m)*c(b),M=i*c(v)*k(y)+s*c(m)*k(b),_=i*k(v)+s*k(m),g=a(_,L(C(O,2)+C(M,2))),w=a(M,O),S=new google.maps.LatLng(g/(o/180),w/(o/180)),d.push(S),E++;return A=function(){switch(r){case"past":return"#888";case"present":return"#f44";default:return"#FF9601"}}(),N=new google.maps.Polyline({map:e,path:d,strokeColor:A,strokeWeight:3,strokeOpacity:1})},window.filterTournaments=function(e,t){return $.map(t,function(t){var n;return n=e.filter(function(e){return e.name===t}),n.length>0?n[0]:typeof console!="undefined"&&console!==null?console.log("Tournament not found: "+t):void 0})},window.drawMapWithSchedule=function(t){var n,r,i;return n=getMap(),i=void 0,r=void 0,$.each(t,function(t,s){var o,u,a,f,l,c;if(s.type==="daviscup")return;return o=getTournamentLogo(s.type,s.name),c=getTournamentPriority(s.type),l=new google.maps.LatLng(s.latitude,s.longitude),a=new google.maps.Marker({position:l,map:n,icon:o,zIndex:c}),u=new google.maps.InfoWindow({content:getInfoWindowContent(s)}),google.maps.event.addListener(a,"click",function(){return u.open(n,a)}),i&&(f=isFuture(i.start)?"future":isFuture(s.start)?"present":"past",e(n,r,a,f)),i=s,r=a})},window.generateScheduleHtml=function(e){var t;return t="",$.each(e,function(e,n){var r,i;return i=getAtpUrl(n.url),r=getTournamentLogo(n.type,n.name),t+='<div class="tournament '+(isFuture(n.start)?"future":void 0)+'">\n  <div class="start">'+n.start+'</div>\n  <div class="logo"><a href="'+i+'" target="_new"><img src="'+r+'"/></a></div>\n  <div class="name"><a href="'+i+'" target="_new">'+n.name+"</a></div>\n</div>"}),t}}).call(this);