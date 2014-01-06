(function(){var e,t,n,r,i,s,o,u,a,f,l,c,h,p,d,v,m,g={}.hasOwnProperty,y=[].slice,b=function(e,t){function r(){this.constructor=e}for(var n in t)g.call(t,n)&&(e[n]=t[n]);return r.prototype=t.prototype,e.prototype=new r,e.__super__=t.prototype,e};f="0.5.0",i={},s={},o={},h=function(e){return typeof (e!=null?e.promise:void 0)=="function"},c=function(e,t){var n,r,i;i=[];for(n in t){if(!g.call(t,n))continue;r=t[n],i.push(e[n]=r)}return i},d=null,v=function(e,t){if(typeof t=="object"&&t!==null){if(d.indexOf(t)>=0)return;d.push(t)}return t},p=function(e){var t;return d=[],t=JSON.stringify(e,v),d=null,t},m=function(){var e,t;return e=1<=arguments.length?y.call(arguments,0):[],t=p(e),t.replace(/"/g,"'").substring(1,t.length-1)},r={process:function(){var e,t,n,r;t=arguments[0],n=arguments[1],e=3<=arguments.length?y.call(arguments,2):[],(r=this.market).log.apply(r,["InUse.process",t,n].concat(y.call(e)));try{return this.in_use_keys.push(t),this.process_.apply(this,[t,n].concat(y.call(e)))}finally{this.in_use_keys.splice(this.in_use_keys.indexOf(t),1)}},processing:function(e){return this.in_use_keys.indexOf(e)>=0}},a=function(){function e(e){this.market=e,this.storage=[]}return e.prototype.clear=function(){return this.storage=[]},e.prototype.add=function(e,r){var i,s;return s=this.storage.length>0?this.storage[this.storage.length-1]:void 0,s instanceof n&&!s.accept(e)?s[e]=r:(typeof e=="string"?(i=new n(this.market),i[e]=r):i=new t(this.market,e,r),this.storage.push(i)),r},e.prototype.removeProvider=function(e){var t,r,i,s,o,u;o=this.storage,u=[];for(t=i=0,s=o.length;i<s;t=++i)r=o[t],r instanceof n?(r.removeProvider(e),r.isEmpty?u.push(this.storage.splice(t,1)):u.push(void 0)):r.provider===e?u.push(this.storage.splice(t,1)):u.push(void 0);return u},e.prototype.accept=function(e){var t,n,r,i;i=this.storage;for(n=0,r=i.length;n<r;n++){t=i[n];if(t.accept(e))return!0}},e.prototype.process=function(){var e,t,n,r,u,a,f,l,c,h,p,d,v,m;r=arguments[0],u=arguments[1],e=3<=arguments.length?y.call(arguments,2):[],(d=this.market).log.apply(d,["Registry.process",r,u].concat(y.call(e)));if(this.storage.length===0)return o;if(u.all){f=[],a=!1,v=this.storage;for(c=0,p=v.length;c<p;c++){n=v[c];if(!n.accept(r))continue;if(n.processing(r))continue;a=!0,l=n.process.apply(n,[r,u].concat(y.call(e))),l!==i&&f.push(l)}return a?f:o}a=!1;for(t=h=m=this.storage.length-1;m<=0?h<=0:h>=0;t=m<=0?++h:--h){n=this.storage[t];if(!n.accept(r))continue;if(n.processing(r))continue;a=!0,f=n.process.apply(n,[r,u].concat(y.call(e)));if(f===s)break;if(f!==i)return f}return a?i:o},e}(),n=function(){function e(e){this.market=e,this.in_use_keys=[]}return c(e.prototype,r),e.prototype.accept=function(e){return this[e]},e.prototype.isEmpty=function(){var e;for(e in this){if(!g.call(this,e))continue;if(e!=="in_use_keys")return!1}return!0},e.prototype.removeProvider=function(e){var t,n,r;r=[];for(t in this){if(!g.call(this,t))continue;n=this[t],n===e?r.push(delete this[t]):r.push(void 0)}return r},e.prototype.process_=function(){var e,t,n,r,i;t=arguments[0],n=arguments[1],e=3<=arguments.length?y.call(arguments,2):[],(i=this.market).log.apply(i,["HashRegistry.process_",t,n].concat(y.call(e))),r=this[t];if(!r)return o;try{return n.provider=r,r.process.apply(r,[n].concat(y.call(e)))}finally{delete n.provider}},e}(),t=function(){function e(e,t,n){this.market=e,this.fuzzy_key=t,this.provider=n,this.in_use_keys=[]}return c(e.prototype,r),e.prototype.accept=function(e){var t,n,r,i;this.market.log("FuzzyRegistry.accept",e);if(this.fuzzy_key instanceof RegExp)return e.match(this.fuzzy_key);if(Object.prototype.toString.call(this.fuzzy_key)==="[object Array]"){i=this.fuzzy_key;for(n=0,r=i.length;n<r;n++){t=i[n];if(t instanceof String){if(t===e)return!0}else if(e.match(t))return!0}}},e.prototype.process_=function(){var e,t,n,r,i;t=arguments[0],n=arguments[1],e=3<=arguments.length?y.call(arguments,2):[],(r=this.market).log.apply(r,["FuzzyRegistry.process_",t,n].concat(y.call(e)));if(!this.accept(t))return o;try{return n.provider=this.provider,(i=this.provider).process.apply(i,[n].concat(y.call(e)))}finally{delete n.provider}},e}(),u=function(){function e(e,t){this.market=e,this.value=t,this.market.log("Provider.constructor",this.value)}return e.prototype.process=function(){var e,t,n,r;return e=1<=arguments.length?y.call(arguments,0):[],(r=this.market).log.apply(r,["Provider.process"].concat(y.call(e))),n=typeof this.value=="function"?this.value.apply(this,e):this.value,t=e[0],(t!=null?t.async:void 0)?h(n)?n:(new Deferred).resolve(n):n},e.prototype.deregister=function(){return FreeMart.deregister(this)},e}(),l=function(e){function t(){return t.__super__.constructor.apply(this,arguments)}return b(t,e),t.prototype.process=function(){var e,t,n,r;return e=1<=arguments.length?y.call(arguments,0):[],(r=this.market).log.apply(r,["ValueProvider.process"].concat(y.call(e))),n=this.value,t=e[0],(t!=null?t.async:void 0)?(new Deferred).resolve(n):n},t}(u),e=function(){function t(e){this.name=e,this.name||(this.name="Black Market"),this.queues={},this.registry=new a(this),this.disableLog()}var e;return t.prototype.register=function(e,t){var n,r,s,o,a,f,l,c;this.log("register",e,t),r=new u(this,t),this.registry.add(e,r);if(this.queues[e]){l=this.queues[e];for(a=0,f=l.length;a<f;a++){s=l[a],this.log.apply(this,["register - deferred request",e].concat(y.call(s.args))),o=(c=this.registry).process.apply(c,[e,{async:!0}].concat(y.call(s.args))),this.log("register - deferred request result",o);if(o===i)throw"NOT FOUND: "+e;h(o)?(n=function(e){return o.then(function(){var t;return t=1<=arguments.length?y.call(arguments,0):[],e.resolve.apply(e,t)},function(){var t;return t=1<=arguments.length?y.call(arguments,0):[],e.reject.apply(e,t)})},n(s)):s.resolve(o)}delete this.queues[e]}return r},t.prototype.value=function(e,t){var n,r,s,o,u,a,f,c;this.log("value",e,t),r=new l(this,t),this.registry.add(e,r);if(this.queues[e]){f=this.queues[e];for(u=0,a=f.length;u<a;u++){s=f[u],this.log.apply(this,["register - deferred request",e].concat(y.call(s.args))),o=(c=this.registry).process.apply(c,[e,{async:!0}].concat(y.call(s.args))),this.log("register - deferred request result",o);if(o===i)throw"NOT FOUND: "+e;h(o)?(n=function(e){return o.then(function(){var t;return t=1<=arguments.length?y.call(arguments,0):[],e.resolve.apply(e,t)},function(){var t;return t=1<=arguments.length?y.call(arguments,0):[],e.reject.apply(e,t)})},n(s)):s.resolve(o)}delete this.queues[e]}return r},t.prototype.deregister=function(e){return this.log("deregister",e),this.registry.removeProvider(e)},t.prototype.request=function(){var e,t,n,r;t=arguments[0],e=2<=arguments.length?y.call(arguments,1):[],this.log.apply(this,["request",t].concat(y.call(e))),n=(r=this.registry).process.apply(r,[t,{}].concat(y.call(e)));if(n===o)throw"NO PROVIDER: "+t;if(n===i)throw"NOT FOUND: "+t;return n},e=function(){var e,t,n;return t=arguments[0],e=2<=arguments.length?y.call(arguments,1):[],n=new Deferred,n.key=t,n.args=e,n},t.prototype.requestAsync=function(){var t,n,r,s,u,a;n=arguments[0],t=2<=arguments.length?y.call(arguments,1):[],this.log.apply(this,["requestAsync",n].concat(y.call(t))),s=(a=this.registry).process.apply(a,[n,{async:!0}].concat(y.call(t)));if(s===o)return r=e.apply(null,[n].concat(y.call(t))),(u=this.queues)[n]||(u[n]=[]),this.queues[n].push(r),r;if(s===i)throw"NOT FOUND: "+n;return s},t.prototype.requestMulti=function(){var e,t,n,r,i;t=1<=arguments.length?y.call(arguments,0):[],this.log.apply(this,["requestMulti"].concat(y.call(t))),i=[];for(n=0,r=t.length;n<r;n++)e=t[n],Object.prototype.toString.call(e)==="[object Array]"?i.push(this.request.apply(this,e)):i.push(this.request(e));return i},t.prototype.requestMultiAsync=function(){var e,t,n;return t=1<=arguments.length?y.call(arguments,0):[],this.log.apply(this,["requestMultiAsync"].concat(y.call(t))),n=function(){var n,r,i;i=[];for(n=0,r=t.length;n<r;n++)e=t[n],typeof e=="object"&&e.length?i.push(this.requestAsync.apply(this,e)):i.push(this.requestAsync(e));return i}.call(this),Deferred.when.apply(Deferred,n)},t.prototype.requestAll=function(){var e,t,n;return t=arguments[0],e=2<=arguments.length?y.call(arguments,1):[],this.log.apply(this,["requestAll",t].concat(y.call(e))),(n=this.registry).process.apply(n,[t,{all:!0}].concat(y.call(e)))},t.prototype.requestAllAsync=function(){var e,t,n,r,i;return t=arguments[0],e=2<=arguments.length?y.call(arguments,1):[],this.log.apply(this,["requestAllAsync",t].concat(y.call(e))),r=new Deferred,n=(i=this.registry).process.apply(i,[t,{all:!0,async:!0}].concat(y.call(e))),Deferred.when.apply(Deferred,n).then(function(){var e;return e=1<=arguments.length?y.call(arguments,0):[],r.resolve(e)},function(){var e;return e=1<=arguments.length?y.call(arguments,0):[],r.reject(e)}),r},t.prototype.registerAsync=function(e,t){return this.log("registerAsync",e,t),this.register(e,function(){var e,n,r;return e=1<=arguments.length?y.call(arguments,0):[],h(t)?t:(r=new Deferred,typeof t=="function"?(n=e[0],n.deferred=r,t.apply(null,e)):r.resolve(t),r)})},t.prototype.clear=function(){return this.registry.clear()},t.prototype.log=function(){var e,t;return e=1<=arguments.length?y.call(arguments,0):[],t=e.shift(),console.log(""+this.name+" - "+t+": "+m.apply(null,e))},t.prototype.disableLog=function(){if(!this.log_)return this.log_=this.log,this.log=function(){}},t.prototype.enableLog=function(){if(this.log_)return this.log=this.log_,delete this.log_},t.prototype.NOT_FOUND=i,t.prototype.NOT_FOUND_FINAL=s,t.prototype.VERSION=f,t}(),e.prototype.req=e.prototype.request,e.prototype.reqAsync=e.prototype.requestAsync,e.prototype.reqMulti=e.prototype.requestMulti,e.prototype.reqMultiAsync=e.prototype.requestMultiAsync,e.prototype.reqAll=e.prototype.requestAll,e.prototype.reqAllAsync=e.prototype.requestAllAsync,this.FreeMart=new e("Free Mart"),this.FreeMart.clone=function(t){return new e(t)}}).call(this);