(function(){T.def("tournaments",function(){return[["p","Please zoom in to see ATP500 and ATP250 tournaments."],["#map"],["p","Please zoom in to see ATP500 and ATP250 tournaments."]]}),router.get("/tournaments",function(){return console.log("tournaments"),T("tournaments").render({inside:".main"}),loadData("tournaments",function(e){var t,n,r;return r=getMap(),n=[],t=[],$.each(e.data,function(e,i){var s,o,u,a,f,l,c;if(i.type==="daviscup")return;s=getTournamentLogo(i.type,i.name),l=getTournamentPriority(i.type),f=(c=i.type)!=="atp250"&&c!=="atp500",a=new google.maps.LatLng(i.latitude,i.longitude),u=new google.maps.Marker({position:a,map:f?r:null,icon:s,zIndex:l});switch(i.type){case"atp250":t.push(u);break;case"atp500":n.push(u)}return o=new google.maps.InfoWindow({content:T("tournament-info-window",i).toString()}),google.maps.event.addListener(u,"click",function(){return o.open(r,u)})}),google.maps.event.addListener(r,"zoom_changed",function(){var e;return e=r.getZoom(),e<=4?$.each(t,function(e,t){return t.setMap(null)}):$.each(t,function(e,t){return t.setMap(r)}),e<=3?$.each(n,function(e,t){return t.setMap(null)}):$.each(n,function(e,t){return t.setMap(r)})})})})}).call(this);