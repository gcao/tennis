/*
 Copyright 2011 Paul Kinlan

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
var routes=function(){var e=[],t=this;this.parseRoute=function(e){return this.parseGroups=function(e){var t=new RegExp(":([^/.\\\\]+)","g"),n=""+e,r={},i=null,s=0;while(i=t.exec(e))r[i[1]]=s++,n=n.replace(i[0],"([^/.\\\\]+)");return n+="$",{groups:r,regexp:new RegExp(n)}},this.parseGroups(e)};var n=function(e,t){var n=e.indexOf(t);return n>=0?[e.slice(0,n),e.slice(n+1)]:[e,null]},r=function(e){var t={},r=e.split("&");for(var i in r){var s=r[i];if(s.indexOf("=")<0)t[decodeURIComponent(s)]=!0;else{var o=n(s,"=");t[decodeURIComponent(o[0])]=decodeURIComponent(o[1])}}return t},i=function(t,i,s){var o=n(t,"?"),u=o[0],a=o[1];for(var f=0;;f++){var l=e[f],c=l.regex.regexp.exec(u);if(!!c==0)continue;if(i&&i!=l.method)continue;var h={};for(var p in l.regex.groups){var d=l.regex.groups[p];h[p]=c[d+1]}var v={};if(s&&s.target instanceof HTMLFormElement){var m=s.target,g=m.length,y;for(var b=0;y=m[b];b++)!y.name||(v[y.name]=y.value)}if(a){var w=r(a);for(key in w)h[key]=w[key]}return routes.matched={url:t,params:h,values:v,e:s},l.callback(routes.matched),!0}return!1};this.get=function(t,n){e.push({regex:this.parseRoute(t),callback:n,method:"get"})},this.post=function(t,n){e.push({regex:this.parseRoute(t),callback:n,method:"post"})},this.test=function(e){i(e)},this.getRoutes=function(){return e};var s=function(){var e=!1,n=!1,r=!1;if(!!window.history&&!!window.history.pushState){var s=history.__proto__.pushState;history.__proto__.pushState=function(e,t,n){s.apply(history,arguments);var r=document.createEvent("Event");r.initEvent("statechanged",!1,!1),r.state=e,window.dispatchEvent(r);return}}t.run=function(){e||(i(document.location.hash),e=!0)},window.addEventListener("submit",function(e){return e.target.method=="post"&&i(e.target.action,"post",e)?(e.preventDefault(),!1):!0}),window.addEventListener("popstate",function(e){if(r){r=!1,n=!1;return}i(document.location.hash),n=!0},!1),window.addEventListener("load",function(t){e||(i(document.location.hash),e=!0),n=!0,r=!0},!1),window.addEventListener("hashchange",function(e){if(n){n=!1,r=!1;return}i(document.location.hash)},!1)};s()};