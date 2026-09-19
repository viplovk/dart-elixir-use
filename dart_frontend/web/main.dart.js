(function dartProgram(){function copyProperties(a,b){var t=Object.keys(a)
for(var s=0;s<t.length;s++){var r=t[s]
b[r]=a[r]}}function mixinPropertiesHard(a,b){var t=Object.keys(a)
for(var s=0;s<t.length;s++){var r=t[s]
if(!b.hasOwnProperty(r)){b[r]=a[r]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var t=function(){}
t.prototype={p:{}}
var s=new t()
if(!(Object.getPrototypeOf(s)&&Object.getPrototypeOf(s).p===t.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var r=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(r))return true}}catch(q){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var t=Object.create(b.prototype)
copyProperties(a.prototype,t)
a.prototype=t}}function inheritMany(a,b){for(var t=0;t<b.length;t++){inherit(b[t],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var t=a
a[b]=t
a[c]=function(){if(a[b]===t){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var t=a
a[b]=t
a[c]=function(){if(a[b]===t){var s=d()
if(a[b]!==t){A.cY(b)}a[b]=s}var r=a[b]
a[c]=function(){return r}
return r}}function makeConstList(a,b){if(b!=null)A.ay(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var t=0;t<a.length;++t){convertToFastObject(a[t])}}var y=0
function instanceTearOffGetter(a,b){var t=null
return a?function(c){if(t===null)t=A.aQ(b)
return new t(c,this)}:function(){if(t===null)t=A.aQ(b)
return new t(this,null)}}function staticTearOffGetter(a){var t=null
return function(){if(t===null)t=A.aQ(a).prototype
return t}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var t=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var s=staticTearOffGetter(t)
a[b]=s}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var t=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var s=instanceTearOffGetter(c,t)
a[b]=s}function setOrUpdateInterceptorsByTag(a){var t=v.interceptorsByTag
if(!t){v.interceptorsByTag=a
return}copyProperties(a,t)}function setOrUpdateLeafTags(a){var t=v.leafTags
if(!t){v.leafTags=a
return}copyProperties(a,t)}function updateTypes(a){var t=v.types
var s=t.length
t.push.apply(t,a)
return s}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var t=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},s=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:t(0,0,null,["$0"],0),_instance_1u:t(0,1,null,["$1"],0),_instance_2u:t(0,2,null,["$2"],0),_instance_0i:t(1,0,null,["$0"],0),_instance_1i:t(1,1,null,["$1"],0),_instance_2i:t(1,2,null,["$2"],0),_static_0:s(0,null,["$0"],0),_static_1:s(1,null,["$1"],0),_static_2:s(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
aU(a,b,c,d){return{i:a,p:b,e:c,x:d}},
aS(a){var t,s,r,q,p,o="_$dart_js",n=a[v.dispatchPropertyName]
if(n==null)if($.aT==null){A.cO()
n=a[v.dispatchPropertyName]}if(n!=null){t=n.p
if(!1===t)return n.i
if(!0===t)return a
s=Object.getPrototypeOf(a)
if(t===s)return n.i
if(n.e===s)throw A.j(A.b3("Return interceptor for "+A.N(t(a,n))))}r=a.constructor
if(r==null)q=null
else{p=$.au
if(p==null)p=$.au=A.aB(o)
q=r[p]}if(q!=null)return q
q=A.cT(a)
if(q!=null)return q
if(typeof a=="function")return B.n
t=Object.getPrototypeOf(a)
if(t==null)return B.d
if(t===Object.prototype)return B.d
if(typeof r=="function"){p=$.au
if(p==null)p=$.au=A.aB(o)
Object.defineProperty(r,p,{value:B.a,enumerable:false,writable:true,configurable:true})
return B.a}return B.a},
T(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.a4.prototype
return J.a5.prototype}if(typeof a=="string")return J.J.prototype
if(a==null)return J.I.prototype
if(typeof a=="boolean")return J.a3.prototype
if(Array.isArray(a))return J.l.prototype
if(typeof a!="object"){if(typeof a=="function")return J.p.prototype
if(typeof a=="symbol")return J.L.prototype
if(typeof a=="bigint")return J.K.prototype
return a}if(a instanceof A.f)return a
return J.aS(a)},
cJ(a){if(typeof a=="string")return J.J.prototype
if(a==null)return a
if(Array.isArray(a))return J.l.prototype
if(typeof a!="object"){if(typeof a=="function")return J.p.prototype
if(typeof a=="symbol")return J.L.prototype
if(typeof a=="bigint")return J.K.prototype
return a}if(a instanceof A.f)return a
return J.aS(a)},
cK(a){if(a==null)return a
if(Array.isArray(a))return J.l.prototype
if(typeof a!="object"){if(typeof a=="function")return J.p.prototype
if(typeof a=="symbol")return J.L.prototype
if(typeof a=="bigint")return J.K.prototype
return a}if(a instanceof A.f)return a
return J.aS(a)},
bA(a){return J.cK(a).gm(a)},
bB(a){return J.T(a).gi(a)},
U(a){return J.T(a).h(a)},
H:function H(){},
a3:function a3(){},
I:function I(){},
d:function d(){},
q:function q(){},
a7:function a7(){},
P:function P(){},
p:function p(){},
K:function K(){},
L:function L(){},
l:function l(a){this.$ti=a},
a2:function a2(){},
al:function al(a){this.$ti=a},
Y:function Y(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ak:function ak(){},
a4:function a4(){},
a5:function a5(){},
J:function J(){}},A={aH:function aH(){},
cS(a){var t,s
for(t=$.az.length,s=0;s<t;++s)if(a===$.az[s])return!0
return!1},
am:function am(a){this.a=a},
a6:function a6(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bw(a){var t=A.bv(a)
if(t!=null)return t
return"minified:"+a},
df(a,b){var t
if(b!=null){t=b.x
if(t!=null)return t}return u.p.b(a)},
N(a){var t
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
t=J.U(a)
return t},
a8(a){var t,s,r,q
if(a instanceof A.f)return A.k(A.D(a),null)
t=J.T(a)
if(t===B.m||t===B.o||u.o.b(a)){s=B.b(a)
if(s!=="Object"&&s!=="")return s
r=a.constructor
if(typeof r=="function"){q=r.name
if(typeof q=="string"&&q!=="Object"&&q!=="")return q}}return A.k(A.D(a),null)},
bM(a){var t,s,r
if(typeof a=="number"||A.aP(a))return J.U(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.t)return a.h(0)
t=$.bz()
for(s=0;s<1;++s){r=t[s].D(a)
if(r!=null)return r}return"Instance of '"+A.a8(a)+"'"},
j(a){return A.h(a,new Error())},
h(a,b){var t
if(a==null)a=new A.ar()
b.dartException=a
t=A.cZ
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:t})
b.name=""}else b.toString=t
return b},
cZ(){return J.U(this.dartException)},
cX(a,b){throw A.h(a,b==null?new Error():b)},
cW(a){throw A.j(A.b_(a))},
bJ(a1){var t,s,r,q,p,o,n,m,l,k,j=a1.co,i=a1.iS,h=a1.iI,g=a1.nDA,f=a1.aI,e=a1.fs,d=a1.cs,c=e[0],b=d[0],a=j[c],a0=a1.fT
a0.toString
t=i?Object.create(new A.ao().constructor.prototype):Object.create(new A.a_(null,null).constructor.prototype)
t.$initialize=t.constructor
s=i?function static_tear_off(){this.$initialize()}:function tear_off(a2,a3){this.$initialize(a2,a3)}
t.constructor=s
s.prototype=t
t.$_name=c
t.$_target=a
r=!i
if(r)q=A.aZ(c,a,h,g)
else{t.$static_name=c
q=a}t.$S=A.bF(a0,i,h)
t[b]=q
for(p=q,o=1;o<e.length;++o){n=e[o]
if(typeof n=="string"){m=j[n]
l=n
n=m}else l=""
k=d[o]
if(k!=null){if(r)n=A.aZ(l,n,h,g)
t[k]=n}if(o===f)p=n}t.$C=p
t.$R=a1.rC
t.$D=a1.dV
return s},
bF(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.j("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.bD)}throw A.j("Error in functionType of tearoff")},
bG(a,b,c,d){var t=A.aY
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,t)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,t)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,t)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,t)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,t)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,t)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,t)}},
aZ(a,b,c,d){if(c)return A.bI(a,b,d)
return A.bG(b.length,d,a,b)},
bH(a,b,c,d){var t=A.aY,s=A.bE
switch(b?-1:a){case 0:throw A.j(new A.an("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,s,t)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,s,t)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,s,t)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,s,t)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,s,t)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,s,t)
default:return function(e,f,g){return function(){var r=[g(this)]
Array.prototype.push.apply(r,arguments)
return e.apply(f(this),r)}}(d,s,t)}},
bI(a,b,c){var t,s
if($.aW==null)$.aW=A.aV("interceptor")
if($.aX==null)$.aX=A.aV("receiver")
t=b.length
s=A.bH(t,c,a,b)
return s},
aQ(a){return A.bJ(a)},
bD(a,b){return A.aw(v.typeUniverse,A.D(a.a),b)},
aY(a){return a.a},
bE(a){return a.b},
aV(a){var t,s,r,q=new A.a_("receiver","interceptor"),p=Object.getOwnPropertyNames(q)
p.$flags=1
t=p
for(p=t.length,s=0;s<p;++s){r=t[s]
if(q[r]===a)return r}throw A.j(A.bC("Field name "+a+" not found."))},
aB(a){return v.getIsolateTag(a)},
cT(a){var t,s,r,q,p,o=$.bq.$1(a),n=$.aA[o]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.aF[o]
if(t!=null)return t
s=v.interceptorsByTag[o]
if(s==null){r=$.bm.$2(a,o)
if(r!=null){n=$.aA[r]
if(n!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}t=$.aF[r]
if(t!=null)return t
s=v.interceptorsByTag[r]
o=r}}if(s==null)return null
t=s.prototype
q=o[0]
if(q==="!"){n=A.aG(t)
$.aA[o]=n
Object.defineProperty(a,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
return n.i}if(q==="~"){$.aF[o]=t
return t}if(q==="-"){p=A.aG(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}if(q==="+")return A.bt(a,t)
if(q==="*")throw A.j(A.b3(o))
if(v.leafTags[o]===true){p=A.aG(t)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:p,enumerable:false,writable:true,configurable:true})
return p.i}else return A.bt(a,t)},
bt(a,b){var t=Object.getPrototypeOf(a)
Object.defineProperty(t,v.dispatchPropertyName,{value:J.aU(b,t,null,null),enumerable:false,writable:true,configurable:true})
return b},
aG(a){return J.aU(a,!1,null,!!a.$iaI)},
cV(a,b,c){var t=b.prototype
if(v.leafTags[a]===true)return A.aG(t)
else return J.aU(t,c,null,null)},
cO(){if(!0===$.aT)return
$.aT=!0
A.cP()},
cP(){var t,s,r,q,p,o,n,m
$.aA=Object.create(null)
$.aF=Object.create(null)
A.cN()
t=v.interceptorsByTag
s=Object.getOwnPropertyNames(t)
if(typeof window!="undefined"){window
r=function(){}
for(q=0;q<s.length;++q){p=s[q]
o=$.bu.$1(p)
if(o!=null){n=A.cV(p,t[p],o)
if(n!=null){Object.defineProperty(o,v.dispatchPropertyName,{value:n,enumerable:false,writable:true,configurable:true})
r.prototype=o}}}}for(q=0;q<s.length;++q){p=s[q]
if(/^[A-Za-z_]/.test(p)){m=t[p]
t["!"+p]=m
t["~"+p]=m
t["-"+p]=m
t["+"+p]=m
t["*"+p]=m}}},
cN(){var t,s,r,q,p,o,n=B.f()
n=A.B(B.h,A.B(B.i,A.B(B.c,A.B(B.c,A.B(B.j,A.B(B.k,A.B(B.l(B.b),n)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){t=dartNativeDispatchHooksTransformer
if(typeof t=="function")t=[t]
if(Array.isArray(t))for(s=0;s<t.length;++s){r=t[s]
if(typeof r=="function")n=r(n)||n}}q=n.getTag
p=n.getUnknownTag
o=n.prototypeForTag
$.bq=new A.aC(q)
$.bm=new A.aD(p)
$.bu=new A.aE(o)},
B(a,b){return a(b)||b},
cI(a,b){var t=b.length,s=v.rttc[""+t+";"+a]
if(s==null)return null
if(t===0)return s
if(t===s.length)return s.apply(null,b)
return s(b)},
O:function O(){},
t:function t(){},
af:function af(){},
aq:function aq(){},
ao:function ao(){},
a_:function a_(a,b){this.a=a
this.b=b},
an:function an(a){this.a=a},
aC:function aC(a){this.a=a},
aD:function aD(a){this.a=a},
aE:function aE(a){this.a=a},
aJ(a,b){var t=b.c
return t==null?b.c=A.R(a,"b0",[b.x]):t},
b2(a){var t=a.w
if(t===6||t===7)return A.b2(a.x)
return t===11||t===12},
bN(a){return a.as},
aR(a){return A.aM(v.typeUniverse,a,!1)},
w(a0,a1,a2,a3){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a1.w
switch(a){case 5:case 1:case 2:case 3:case 4:return a1
case 6:t=a1.x
s=A.w(a0,t,a2,a3)
if(s===t)return a1
return A.ba(a0,s,!0)
case 7:t=a1.x
s=A.w(a0,t,a2,a3)
if(s===t)return a1
return A.b9(a0,s,!0)
case 8:r=a1.y
q=A.A(a0,r,a2,a3)
if(q===r)return a1
return A.R(a0,a1.x,q)
case 9:p=a1.x
o=A.w(a0,p,a2,a3)
n=a1.y
m=A.A(a0,n,a2,a3)
if(o===p&&m===n)return a1
return A.aK(a0,o,m)
case 10:l=a1.x
k=a1.y
j=A.A(a0,k,a2,a3)
if(j===k)return a1
return A.bb(a0,l,j)
case 11:i=a1.x
h=A.w(a0,i,a2,a3)
g=a1.y
f=A.cF(a0,g,a2,a3)
if(h===i&&f===g)return a1
return A.b8(a0,h,f)
case 12:e=a1.y
a3+=e.length
d=A.A(a0,e,a2,a3)
p=a1.x
o=A.w(a0,p,a2,a3)
if(d===e&&o===p)return a1
return A.aL(a0,o,d,!0)
case 13:c=a1.x
if(c<a3)return a1
b=a2[c-a3]
if(b==null)return a1
return b
default:throw A.j(A.Z("Attempted to substitute unexpected RTI kind "+a))}},
A(a,b,c,d){var t,s,r,q,p=b.length,o=A.ax(p)
for(t=!1,s=0;s<p;++s){r=b[s]
q=A.w(a,r,c,d)
if(q!==r)t=!0
o[s]=q}return t?o:b},
cG(a,b,c,d){var t,s,r,q,p,o,n=b.length,m=A.ax(n)
for(t=!1,s=0;s<n;s+=3){r=b[s]
q=b[s+1]
p=b[s+2]
o=A.w(a,p,c,d)
if(o!==p)t=!0
m.splice(s,3,r,q,o)}return t?m:b},
cF(a,b,c,d){var t,s=b.a,r=A.A(a,s,c,d),q=b.b,p=A.A(a,q,c,d),o=b.c,n=A.cG(a,o,c,d)
if(r===s&&p===q&&n===o)return b
t=new A.aa()
t.a=r
t.b=p
t.c=n
return t},
ay(a,b){a[v.arrayRti]=b
return a},
bo(a){var t=a.$S
if(t!=null){if(typeof t=="number")return A.cM(t)
return a.$S()}return null},
cQ(a,b){var t
if(A.b2(b))if(a instanceof A.t){t=A.bo(a)
if(t!=null)return t}return A.D(a)},
D(a){if(a instanceof A.f)return A.bh(a)
if(Array.isArray(a))return A.aN(a)
return A.aO(J.T(a))},
aN(a){var t=a[v.arrayRti],s=u.b
if(t==null)return s
if(t.constructor!==s.constructor)return s
return t},
bh(a){var t=a.$ti
return t!=null?t:A.aO(a)},
aO(a){var t=a.constructor,s=t.$ccache
if(s!=null)return s
return A.cp(a,t)},
cp(a,b){var t=a instanceof A.t?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,s=A.c3(v.typeUniverse,t.name)
b.$ccache=s
return s},
cM(a){var t,s=v.types,r=s[a]
if(typeof r=="string"){t=A.aM(v.typeUniverse,r,!1)
s[a]=t
return t}return r},
cL(a){return A.C(A.bh(a))},
cE(a){var t=a instanceof A.t?A.bo(a):null
if(t!=null)return t
if(u.R.b(a))return J.bB(a).a
if(Array.isArray(a))return A.aN(a)
return A.D(a)},
C(a){var t=a.r
return t==null?a.r=new A.av(a):t},
co(a){var t=this
t.b=A.cD(t)
return t.b(a)},
cD(a){var t,s,r,q
if(a===u.K)return A.cw
if(A.x(a))return A.cA
t=a.w
if(t===6)return A.cm
if(t===1)return A.bk
if(t===7)return A.cq
s=A.cC(a)
if(s!=null)return s
if(t===8){r=a.x
if(a.y.every(A.x)){a.f="$i"+r
if(r==="bL")return A.cu
if(a===u.m)return A.ct
return A.cz}}else if(t===10){q=A.cI(a.x,a.y)
return q==null?A.bk:q}return A.ck},
cC(a){if(a.w===8){if(a===u.S)return A.cr
if(a===u.i||a===u.H)return A.cv
if(a===u.N)return A.cy
if(a===u.y)return A.aP}return null},
cn(a){var t=this,s=A.cj
if(A.x(t))s=A.ci
else if(t===u.K)s=A.cf
else if(A.E(t)){s=A.cl
if(t===u.t)s=A.ca
else if(t===u.v)s=A.ch
else if(t===u.u)s=A.c6
else if(t===u.n)s=A.ce
else if(t===u.I)s=A.c8
else if(t===u.z)s=A.cc}else if(t===u.S)s=A.c9
else if(t===u.N)s=A.cg
else if(t===u.y)s=A.c5
else if(t===u.H)s=A.cd
else if(t===u.i)s=A.c7
else if(t===u.m)s=A.cb
t.a=s
return t.a(a)},
ck(a){var t=this
if(a==null)return A.E(t)
return A.cR(v.typeUniverse,A.cQ(a,t),t)},
cm(a){if(a==null)return!0
return this.x.b(a)},
cz(a){var t,s=this
if(a==null)return A.E(s)
t=s.f
if(a instanceof A.f)return!!a[t]
return!!J.T(a)[t]},
cu(a){var t,s=this
if(a==null)return A.E(s)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
t=s.f
if(a instanceof A.f)return!!a[t]
return!!J.T(a)[t]},
ct(a){var t=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.f)return!!a[t.f]
return!0}if(typeof a=="function")return!0
return!1},
bj(a){if(typeof a=="object"){if(a instanceof A.f)return u.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
cj(a){var t=this
if(a==null){if(A.E(t))return a}else if(t.b(a))return a
throw A.h(A.bf(a,t),new Error())},
cl(a){var t=this
if(a==null||t.b(a))return a
throw A.h(A.bf(a,t),new Error())},
bf(a,b){return new A.ad("TypeError: "+A.b4(a,A.k(b,null)))},
b4(a,b){return A.ai(a)+": type '"+A.k(A.cE(a),null)+"' is not a subtype of type '"+b+"'"},
m(a,b){return new A.ad("TypeError: "+A.b4(a,b))},
cq(a){var t=this
return t.x.b(a)||A.aJ(v.typeUniverse,t).b(a)},
cw(a){return a!=null},
cf(a){if(a!=null)return a
throw A.h(A.m(a,"Object"),new Error())},
cA(a){return!0},
ci(a){return a},
bk(a){return!1},
aP(a){return!0===a||!1===a},
c5(a){if(!0===a)return!0
if(!1===a)return!1
throw A.h(A.m(a,"bool"),new Error())},
c6(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.h(A.m(a,"bool?"),new Error())},
c7(a){if(typeof a=="number")return a
throw A.h(A.m(a,"double"),new Error())},
c8(a){if(typeof a=="number")return a
if(a==null)return a
throw A.h(A.m(a,"double?"),new Error())},
cr(a){return typeof a=="number"&&Math.floor(a)===a},
c9(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.h(A.m(a,"int"),new Error())},
ca(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.h(A.m(a,"int?"),new Error())},
cv(a){return typeof a=="number"},
cd(a){if(typeof a=="number")return a
throw A.h(A.m(a,"num"),new Error())},
ce(a){if(typeof a=="number")return a
if(a==null)return a
throw A.h(A.m(a,"num?"),new Error())},
cy(a){return typeof a=="string"},
cg(a){if(typeof a=="string")return a
throw A.h(A.m(a,"String"),new Error())},
ch(a){if(typeof a=="string")return a
if(a==null)return a
throw A.h(A.m(a,"String?"),new Error())},
cb(a){if(A.bj(a))return a
throw A.h(A.m(a,"JSObject"),new Error())},
cc(a){if(a==null)return a
if(A.bj(a))return a
throw A.h(A.m(a,"JSObject?"),new Error())},
bl(a,b){var t,s,r
for(t="",s="",r=0;r<a.length;++r,s=", ")t+=s+A.k(a[r],b)
return t},
cB(a,b){var t,s,r,q,p,o,n=a.x,m=a.y
if(""===n)return"("+A.bl(m,b)+")"
t=m.length
s=n.split(",")
r=s.length-t
for(q="(",p="",o=0;o<t;++o,p=", "){q+=p
if(r===0)q+="{"
q+=A.k(m[o],b)
if(r>=0)q+=" "+s[r];++r}return q+"})"},
bg(a0,a1,a2){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=", ",a=null
if(a2!=null){t=a2.length
if(a1==null)a1=A.ay([],u.s)
else a=a1.length
s=a1.length
for(r=t;r>0;--r)a1.push("T"+(s+r))
for(q=u.X,p="<",o="",r=0;r<t;++r,o=b){p=p+o+a1[a1.length-1-r]
n=a2[r]
m=n.w
if(!(m===2||m===3||m===4||m===5||n===q))p+=" extends "+A.k(n,a1)}p+=">"}else p=""
q=a0.x
l=a0.y
k=l.a
j=k.length
i=l.b
h=i.length
g=l.c
f=g.length
e=A.k(q,a1)
for(d="",c="",r=0;r<j;++r,c=b)d+=c+A.k(k[r],a1)
if(h>0){d+=c+"["
for(c="",r=0;r<h;++r,c=b)d+=c+A.k(i[r],a1)
d+="]"}if(f>0){d+=c+"{"
for(c="",r=0;r<f;r+=3,c=b){d+=c
if(g[r+1])d+="required "
d+=A.k(g[r+2],a1)+" "+g[r]}d+="}"}if(a!=null){a1.toString
a1.length=a}return p+"("+d+") => "+e},
k(a,b){var t,s,r,q,p,o,n=a.w
if(n===5)return"erased"
if(n===2)return"dynamic"
if(n===3)return"void"
if(n===1)return"Never"
if(n===4)return"any"
if(n===6){t=a.x
s=A.k(t,b)
r=t.w
return(r===11||r===12?"("+s+")":s)+"?"}if(n===7)return"FutureOr<"+A.k(a.x,b)+">"
if(n===8){q=A.cH(a.x)
p=a.y
return p.length>0?q+("<"+A.bl(p,b)+">"):q}if(n===10)return A.cB(a,b)
if(n===11)return A.bg(a,b,null)
if(n===12)return A.bg(a.x,b,a.y)
if(n===13){o=a.x
return b[b.length-1-o]}return"?"},
cH(a){var t=A.bv(a)
if(t!=null)return t
return"minified:"+a},
c4(a,b){var t=a.tR[b]
while(typeof t=="string")t=a.tR[t]
return t},
c3(a,b){var t,s,r,q,p,o=a.eT,n=o[b]
if(n==null)return A.aM(a,b,!1)
else if(typeof n=="number"){t=n
s=A.S(a,5,"#")
r=A.ax(t)
for(q=0;q<t;++q)r[q]=s
p=A.R(a,b,r)
o[b]=p
return p}else return n},
c1(a,b){return A.bd(a.tR,b)},
dd(a,b){return A.bd(a.eT,b)},
aM(a,b,c){var t,s=a.eC,r=s.get(b)
if(r!=null)return r
t=A.bc(a,null,b,!1)
s.set(b,t)
return t},
aw(a,b,c){var t,s,r=b.z
if(r==null)r=b.z=new Map()
t=r.get(c)
if(t!=null)return t
s=A.bc(a,b,c,!0)
r.set(c,s)
return s},
c2(a,b,c){var t,s,r,q=b.Q
if(q==null)q=b.Q=new Map()
t=c.as
s=q.get(t)
if(s!=null)return s
r=A.aK(a,b,c.w===9?c.y:[c])
q.set(t,r)
return r},
bc(a,b,c,d){return A.bV(A.bP(a,b,c,d))},
r(a,b){b.a=A.cn
b.b=A.co
return b},
S(a,b,c){var t,s,r=a.eC.get(c)
if(r!=null)return r
t=new A.n(null,null)
t.w=b
t.as=c
s=A.r(a,t)
a.eC.set(c,s)
return s},
ba(a,b,c){var t,s=b.as+"?",r=a.eC.get(s)
if(r!=null)return r
t=A.c_(a,b,s,c)
a.eC.set(s,t)
return t},
c_(a,b,c,d){var t,s,r
if(d){t=b.w
s=!0
if(!A.x(b))if(!(b===u.P||b===u.T))if(t!==6)s=t===7&&A.E(b.x)
if(s)return b
else if(t===1)return u.P}r=new A.n(null,null)
r.w=6
r.x=b
r.as=c
return A.r(a,r)},
b9(a,b,c){var t,s=b.as+"/",r=a.eC.get(s)
if(r!=null)return r
t=A.bY(a,b,s,c)
a.eC.set(s,t)
return t},
bY(a,b,c,d){var t,s
if(d){t=b.w
if(A.x(b)||b===u.K)return b
else if(t===1)return A.R(a,"b0",[b])
else if(b===u.P||b===u.T)return u.O}s=new A.n(null,null)
s.w=7
s.x=b
s.as=c
return A.r(a,s)},
c0(a,b){var t,s,r=""+b+"^",q=a.eC.get(r)
if(q!=null)return q
t=new A.n(null,null)
t.w=13
t.x=b
t.as=r
s=A.r(a,t)
a.eC.set(r,s)
return s},
Q(a){var t,s,r,q=a.length
for(t="",s="",r=0;r<q;++r,s=",")t+=s+a[r].as
return t},
bX(a){var t,s,r,q,p,o=a.length
for(t="",s="",r=0;r<o;r+=3,s=","){q=a[r]
p=a[r+1]?"!":":"
t+=s+q+p+a[r+2].as}return t},
R(a,b,c){var t,s,r,q=b
if(c.length>0)q+="<"+A.Q(c)+">"
t=a.eC.get(q)
if(t!=null)return t
s=new A.n(null,null)
s.w=8
s.x=b
s.y=c
if(c.length>0)s.c=c[0]
s.as=q
r=A.r(a,s)
a.eC.set(q,r)
return r},
aK(a,b,c){var t,s,r,q,p,o
if(b.w===9){t=b.x
s=b.y.concat(c)}else{s=c
t=b}r=t.as+(";<"+A.Q(s)+">")
q=a.eC.get(r)
if(q!=null)return q
p=new A.n(null,null)
p.w=9
p.x=t
p.y=s
p.as=r
o=A.r(a,p)
a.eC.set(r,o)
return o},
bb(a,b,c){var t,s,r="+"+(b+"("+A.Q(c)+")"),q=a.eC.get(r)
if(q!=null)return q
t=new A.n(null,null)
t.w=10
t.x=b
t.y=c
t.as=r
s=A.r(a,t)
a.eC.set(r,s)
return s},
b8(a,b,c){var t,s,r,q,p,o=b.as,n=c.a,m=n.length,l=c.b,k=l.length,j=c.c,i=j.length,h="("+A.Q(n)
if(k>0){t=m>0?",":""
h+=t+"["+A.Q(l)+"]"}if(i>0){t=m>0?",":""
h+=t+"{"+A.bX(j)+"}"}s=o+(h+")")
r=a.eC.get(s)
if(r!=null)return r
q=new A.n(null,null)
q.w=11
q.x=b
q.y=c
q.as=s
p=A.r(a,q)
a.eC.set(s,p)
return p},
aL(a,b,c,d){var t,s=b.as+("<"+A.Q(c)+">"),r=a.eC.get(s)
if(r!=null)return r
t=A.bZ(a,b,c,s,d)
a.eC.set(s,t)
return t},
bZ(a,b,c,d,e){var t,s,r,q,p,o,n,m
if(e){t=c.length
s=A.ax(t)
for(r=0,q=0;q<t;++q){p=c[q]
if(p.w===1){s[q]=p;++r}}if(r>0){o=A.w(a,b,s,0)
n=A.A(a,c,s,0)
return A.aL(a,o,n,c!==n)}}m=new A.n(null,null)
m.w=12
m.x=b
m.y=c
m.as=d
return A.r(a,m)},
bP(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
bV(a){var t,s,r,q,p,o,n,m=a.r,l=a.s
for(t=m.length,s=0;s<t;){r=m.charCodeAt(s)
if(r>=48&&r<=57)s=A.bR(s+1,r,m,l)
else if((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124)s=A.b6(a,s,m,l,!1)
else if(r===46)s=A.b6(a,s,m,l,!0)
else{++s
switch(r){case 44:break
case 58:l.push(!1)
break
case 33:l.push(!0)
break
case 59:l.push(A.v(a.u,a.e,l.pop()))
break
case 94:l.push(A.c0(a.u,l.pop()))
break
case 35:l.push(A.S(a.u,5,"#"))
break
case 64:l.push(A.S(a.u,2,"@"))
break
case 126:l.push(A.S(a.u,3,"~"))
break
case 60:l.push(a.p)
a.p=l.length
break
case 62:A.bT(a,l)
break
case 38:A.bS(a,l)
break
case 63:q=a.u
l.push(A.ba(q,A.v(q,a.e,l.pop()),a.n))
break
case 47:q=a.u
l.push(A.b9(q,A.v(q,a.e,l.pop()),a.n))
break
case 40:l.push(-3)
l.push(a.p)
a.p=l.length
break
case 41:A.bQ(a,l)
break
case 91:l.push(a.p)
a.p=l.length
break
case 93:p=l.splice(a.p)
A.b7(a.u,a.e,p)
a.p=l.pop()
l.push(p)
l.push(-1)
break
case 123:l.push(a.p)
a.p=l.length
break
case 125:p=l.splice(a.p)
A.bW(a.u,a.e,p)
a.p=l.pop()
l.push(p)
l.push(-2)
break
case 43:o=m.indexOf("(",s)
l.push(m.substring(s,o))
l.push(-4)
l.push(a.p)
a.p=l.length
s=o+1
break
default:throw"Bad character "+r}}}n=l.pop()
return A.v(a.u,a.e,n)},
bR(a,b,c,d){var t,s,r=b-48
for(t=c.length;a<t;++a){s=c.charCodeAt(a)
if(!(s>=48&&s<=57))break
r=r*10+(s-48)}d.push(r)
return a},
b6(a,b,c,d,e){var t,s,r,q,p,o,n=b+1
for(t=c.length;n<t;++n){s=c.charCodeAt(n)
if(s===46){if(e)break
e=!0}else{if(!((((s|32)>>>0)-97&65535)<26||s===95||s===36||s===124))r=s>=48&&s<=57
else r=!0
if(!r)break}}q=c.substring(b,n)
if(e){t=a.u
p=a.e
if(p.w===9)p=p.x
o=A.c4(t,p.x)[q]
if(o==null)A.cX('No "'+q+'" in "'+A.bN(p)+'"')
d.push(A.aw(t,p,o))}else d.push(q)
return n},
bT(a,b){var t,s=a.u,r=A.b5(a,b),q=b.pop()
if(typeof q=="string")b.push(A.R(s,q,r))
else{t=A.v(s,a.e,q)
switch(t.w){case 11:b.push(A.aL(s,t,r,a.n))
break
default:b.push(A.aK(s,t,r))
break}}},
bQ(a,b){var t,s,r,q=a.u,p=b.pop(),o=null,n=null
if(typeof p=="number")switch(p){case-1:o=b.pop()
break
case-2:n=b.pop()
break
default:b.push(p)
break}else b.push(p)
t=A.b5(a,b)
p=b.pop()
switch(p){case-3:p=b.pop()
if(o==null)o=q.sEA
if(n==null)n=q.sEA
s=A.v(q,a.e,p)
r=new A.aa()
r.a=t
r.b=o
r.c=n
b.push(A.b8(q,s,r))
return
case-4:b.push(A.bb(q,b.pop(),t))
return
default:throw A.j(A.Z("Unexpected state under `()`: "+A.N(p)))}},
bS(a,b){var t=b.pop()
if(0===t){b.push(A.S(a.u,1,"0&"))
return}if(1===t){b.push(A.S(a.u,4,"1&"))
return}throw A.j(A.Z("Unexpected extended operation "+A.N(t)))},
b5(a,b){var t=b.splice(a.p)
A.b7(a.u,a.e,t)
a.p=b.pop()
return t},
v(a,b,c){if(typeof c=="string")return A.R(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.bU(a,b,c)}else return c},
b7(a,b,c){var t,s=c.length
for(t=0;t<s;++t)c[t]=A.v(a,b,c[t])},
bW(a,b,c){var t,s=c.length
for(t=2;t<s;t+=3)c[t]=A.v(a,b,c[t])},
bU(a,b,c){var t,s,r=b.w
if(r===9){if(c===0)return b.x
t=b.y
s=t.length
if(c<=s)return t[c-1]
c-=s
b=b.x
r=b.w}else if(c===0)return b
if(r!==8)throw A.j(A.Z("Indexed base must be an interface type"))
t=b.y
if(c<=t.length)return t[c-1]
throw A.j(A.Z("Bad index "+c+" for "+b.h(0)))},
cR(a,b,c){var t,s=b.d
if(s==null)s=b.d=new Map()
t=s.get(c)
if(t==null){t=A.e(a,b,null,c,null)
s.set(c,t)}return t},
e(a,b,c,d,e){var t,s,r,q,p,o,n,m,l,k,j
if(b===d)return!0
if(A.x(d))return!0
t=b.w
if(t===4)return!0
if(A.x(b))return!1
if(b.w===1)return!0
s=t===13
if(s)if(A.e(a,c[b.x],c,d,e))return!0
r=d.w
q=u.P
if(b===q||b===u.T){if(r===7)return A.e(a,b,c,d.x,e)
return d===q||d===u.T||r===6}if(d===u.K){if(t===7)return A.e(a,b.x,c,d,e)
return t!==6}if(t===7){if(!A.e(a,b.x,c,d,e))return!1
return A.e(a,A.aJ(a,b),c,d,e)}if(t===6)return A.e(a,q,c,d,e)&&A.e(a,b.x,c,d,e)
if(r===7){if(A.e(a,b,c,d.x,e))return!0
return A.e(a,b,c,A.aJ(a,d),e)}if(r===6)return A.e(a,b,c,q,e)||A.e(a,b,c,d.x,e)
if(s)return!1
q=t!==11
if((!q||t===12)&&d===u.Z)return!0
p=t===10
if(p&&d===u.L)return!0
if(r===12){if(b===u.g)return!0
if(t!==12)return!1
o=b.y
n=d.y
m=o.length
if(m!==n.length)return!1
c=c==null?o:o.concat(c)
e=e==null?n:n.concat(e)
for(l=0;l<m;++l){k=o[l]
j=n[l]
if(!A.e(a,k,c,j,e)||!A.e(a,j,e,k,c))return!1}return A.bi(a,b.x,c,d.x,e)}if(r===11){if(b===u.g)return!0
if(q)return!1
return A.bi(a,b,c,d,e)}if(t===8){if(r!==8)return!1
return A.cs(a,b,c,d,e)}if(p&&r===10)return A.cx(a,b,c,d,e)
return!1},
bi(a2,a3,a4,a5,a6){var t,s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1
if(!A.e(a2,a3.x,a4,a5.x,a6))return!1
t=a3.y
s=a5.y
r=t.a
q=s.a
p=r.length
o=q.length
if(p>o)return!1
n=o-p
m=t.b
l=s.b
k=m.length
j=l.length
if(p+k<o+j)return!1
for(i=0;i<p;++i){h=r[i]
if(!A.e(a2,q[i],a6,h,a4))return!1}for(i=0;i<n;++i){h=m[i]
if(!A.e(a2,q[p+i],a6,h,a4))return!1}for(i=0;i<j;++i){h=m[n+i]
if(!A.e(a2,l[i],a6,h,a4))return!1}g=t.c
f=s.c
e=g.length
d=f.length
for(c=0,b=0;b<d;b+=3){a=f[b]
for(;;){if(c>=e)return!1
a0=g[c]
c+=3
if(a<a0)return!1
a1=g[c-2]
if(a0<a){if(a1)return!1
continue}h=f[b+1]
if(a1&&!h)return!1
h=g[c-1]
if(!A.e(a2,f[b+2],a6,h,a4))return!1
break}}while(c<e){if(g[c+1])return!1
c+=3}return!0},
cs(a,b,c,d,e){var t,s,r,q,p,o=b.x,n=d.x
while(o!==n){t=a.tR[o]
if(t==null)return!1
if(typeof t=="string"){o=t
continue}s=t[n]
if(s==null)return!1
r=s.length
q=r>0?new Array(r):v.typeUniverse.sEA
for(p=0;p<r;++p)q[p]=A.aw(a,b,s[p])
return A.be(a,q,null,c,d.y,e)}return A.be(a,b.y,null,c,d.y,e)},
be(a,b,c,d,e,f){var t,s=b.length
for(t=0;t<s;++t)if(!A.e(a,b[t],d,e[t],f))return!1
return!0},
cx(a,b,c,d,e){var t,s=b.y,r=d.y,q=s.length
if(q!==r.length)return!1
if(b.x!==d.x)return!1
for(t=0;t<q;++t)if(!A.e(a,s[t],c,r[t],e))return!1
return!0},
E(a){var t=a.w,s=!0
if(!(a===u.P||a===u.T))if(!A.x(a))if(t!==6)s=t===7&&A.E(a.x)
return s},
x(a){var t=a.w
return t===2||t===3||t===4||t===5||a===u.X},
bd(a,b){var t,s,r=Object.keys(b),q=r.length
for(t=0;t<q;++t){s=r[t]
a[s]=b[s]}},
ax(a){return a>0?new Array(a):v.typeUniverse.sEA},
n:function n(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
aa:function aa(){this.c=this.b=this.a=null},
av:function av(a){this.a=a},
at:function at(){},
ad:function ad(a){this.a=a},
z:function z(){},
bO(a,b,c){var t=J.bA(b)
if(!t.k())return a
if(c.length===0){do a+=A.N(t.gj())
while(t.k())}else{a+=A.N(t.gj())
while(t.k())a=a+c+A.N(t.gj())}return a},
ai(a){if(typeof a=="number"||A.aP(a)||a==null)return J.U(a)
if(typeof a=="string")return JSON.stringify(a)
return A.bM(a)},
Z(a){return new A.ae(a)},
bC(a){return new A.X(!1,null,null,a)},
bK(a,b,c,d){return new A.aj(b,!0,a,d,"Index out of range")},
b3(a){return new A.as(a)},
b_(a){return new A.ag(a)},
b1(a,b,c){var t,s
if(A.cS(a))return b+"..."+c
t=new A.ap(b)
$.az.push(a)
try{s=t
s.a=A.bO(s.a,a,", ")}finally{$.az.pop()}t.a+=c
s=t.a
return s.charCodeAt(0)==0?s:s},
ah:function ah(){},
ae:function ae(a){this.a=a},
ar:function ar(){},
X:function X(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aj:function aj(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
as:function as(a){this.a=a},
ag:function ag(a){this.a=a},
M:function M(){},
f:function f(){},
ap:function ap(a){this.a=a},
b:function b(){},
V:function V(){},
W:function W(){},
F:function F(){},
a0:function a0(){},
a:function a(){},
G:function G(){},
u:function u(){},
c:function c(){},
y:function y(){},
a1:function a1(a,b,c){var _=this
_.a=a
_.b=b
_.c=-1
_.d=null
_.$ti=c},
ab:function ab(){},
ac:function ac(){},
bv(a){return v.mangledGlobalNames[a]},
cY(a){throw A.h(new A.am("Field '"+a+"' has been assigned during initialization."),new Error())},
cU(){var t,s,r,q,p,o=document,n=o.body
n.toString
B.e.C(n)
t=o.createElement("style")
t.textContent='      :root {\n        color-scheme: dark;\n        font-family: Inter, ui-sans-serif, system-ui, -apple-system,\n          BlinkMacSystemFont, "Segoe UI", sans-serif;\n      }\n\n      * { box-sizing: border-box; }\n\n      body {\n        margin: 0;\n        min-height: 100vh;\n        color: #f3f3f3;\n        background:\n          radial-gradient(circle at 1px 1px, rgba(255,255,255,.16) 1px, transparent 1.15px)\n          0 0 / 13px 13px,\n          #202224;\n      }\n\n      .page {\n        min-height: 100vh;\n        padding: 80px 5.6vw 120px;\n      }\n\n      .label {\n        display: flex;\n        align-items: center;\n        gap: 5px;\n        height: 20px;\n        margin-bottom: 1px;\n        font-size: 12px;\n        line-height: 1;\n        font-weight: 500;\n        color: #e6e6e6;\n        letter-spacing: -.01em;\n      }\n\n      .label-icon {\n        position: relative;\n        width: 13px;\n        height: 10px;\n      }\n\n      .label-icon::before,\n      .label-icon::after {\n        content: "";\n        position: absolute;\n        border: 1px solid #e8e8e8;\n        border-radius: 2px;\n      }\n\n      .label-icon::before {\n        width: 8px;\n        height: 7px;\n        left: 0;\n        top: 2px;\n      }\n\n      .label-icon::after {\n        width: 8px;\n        height: 7px;\n        left: 4px;\n        top: 0;\n      }\n\n      .hero {\n        width: 100%;\n        height: 31px;\n        border-radius: 9px;\n        background: #fafafa;\n        color: #1e2a37;\n        display: flex;\n        align-items: center;\n        justify-content: center;\n        font-size: clamp(22px, 2vw, 28px);\n        font-weight: 400;\n        letter-spacing: -.025em;\n        box-shadow:\n          0 0 0 1px rgba(255,255,255,.25),\n          0 1px 2px rgba(0,0,0,.18);\n      }\n\n      @media (max-width: 700px) {\n        .page {\n          padding: 54px 20px 80px;\n        }\n\n        .hero {\n          height: 42px;\n          border-radius: 10px;\n          font-size: 22px;\n        }\n\n        .label {\n          font-size: 11px;\n        }\n      }\n    '
o.head.appendChild(t)
s=o.createElement("div")
s.classList.add("page")
r=o.createElement("div")
r.classList.add("label")
q=o.createElement("span")
q.classList.add("label-icon")
r.appendChild(q)
q=o.createElement("span")
q.textContent="Hello World - Minimal"
r.appendChild(q)
p=o.createElement("div")
p.classList.add("hero")
p.textContent="Hello World"
s.appendChild(r)
s.appendChild(p)
n.appendChild(s)}},B={}
var w=[A,J,B]
var $={}
A.aH.prototype={}
J.H.prototype={
h(a){return"Instance of '"+A.a8(a)+"'"},
gi(a){return A.C(A.aO(this))}}
J.a3.prototype={
h(a){return String(a)},
gi(a){return A.C(u.y)},
$io:1}
J.I.prototype={
h(a){return"null"},
$io:1}
J.d.prototype={$ii:1}
J.q.prototype={
h(a){return String(a)}}
J.a7.prototype={}
J.P.prototype={}
J.p.prototype={
h(a){var t=a[$.by()]
if(t==null)t=a[$.bx()]
if(t==null)return this.B(a)
return"JavaScript function for "+J.U(t)}}
J.K.prototype={
h(a){return String(a)}}
J.L.prototype={
h(a){return String(a)}}
J.l.prototype={
h(a){return A.b1(a,"[","]")},
gm(a){return new J.Y(a,a.length,A.aN(a).l("Y<1>"))}}
J.a2.prototype={
D(a){var t,s,r
if(!Array.isArray(a))return null
t=a.$flags|0
if((t&4)!==0)s="const, "
else if((t&2)!==0)s="unmodifiable, "
else s=(t&1)!==0?"fixed, ":""
r="Instance of '"+A.a8(a)+"'"
if(s==="")return r
return r+" ("+s+"length: "+a.length+")"}}
J.al.prototype={}
J.Y.prototype={
gj(){var t=this.d
return t==null?this.$ti.c.a(t):t},
k(){var t,s=this,r=s.a,q=r.length
if(s.b!==q)throw A.j(A.cW(r))
t=s.c
if(t>=q){s.d=null
return!1}s.d=r[t]
s.c=t+1
return!0}}
J.ak.prototype={
h(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gi(a){return A.C(u.H)}}
J.a4.prototype={
gi(a){return A.C(u.S)},
$io:1}
J.a5.prototype={
gi(a){return A.C(u.i)},
$io:1}
J.J.prototype={
h(a){return a},
gi(a){return A.C(u.N)},
$io:1,
$ia9:1}
A.am.prototype={
h(a){return"LateInitializationError: "+this.a}}
A.a6.prototype={
gj(){var t=this.d
return t==null?this.$ti.c.a(t):t},
k(){var t,s=this,r=s.a,q=J.cJ(r),p=q.gu(r)
if(s.b!==p)throw A.j(A.b_(r))
t=s.c
if(t>=p){s.d=null
return!1}s.d=q.q(r,t);++s.c
return!0}}
A.O.prototype={}
A.t.prototype={
h(a){var t=this.constructor,s=t==null?null:t.name
return"Closure '"+A.bw(s==null?"unknown":s)+"'"},
gE(){return this},
$C:"$1",
$R:1,
$D:null}
A.af.prototype={$C:"$2",$R:2}
A.aq.prototype={}
A.ao.prototype={
h(a){var t=this.$static_name
if(t==null)return"Closure of unknown static method"
return"Closure '"+A.bw(t)+"'"}}
A.a_.prototype={
h(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.a8(this.a)+"'")}}
A.an.prototype={
h(a){return"RuntimeError: "+this.a}}
A.aC.prototype={
$1(a){return this.a(a)}}
A.aD.prototype={
$2(a,b){return this.a(a,b)}}
A.aE.prototype={
$1(a){return this.a(a)}}
A.n.prototype={
l(a){return A.aw(v.typeUniverse,this,a)},
F(a){return A.c2(v.typeUniverse,this,a)}}
A.aa.prototype={}
A.av.prototype={
h(a){return A.k(this.a,null)}}
A.at.prototype={
h(a){return this.a}}
A.ad.prototype={}
A.z.prototype={
gm(a){return new A.a6(a,this.gu(a),A.D(a).l("a6<z.E>"))},
q(a,b){return this.v(a,b)},
h(a){return A.b1(a,"[","]")}}
A.ah.prototype={}
A.ae.prototype={
h(a){var t=this.a
if(t!=null)return"Assertion failed: "+A.ai(t)
return"Assertion failed"}}
A.ar.prototype={}
A.X.prototype={
gp(){return"Invalid argument"+(!this.a?"(s)":"")},
gn(){return""},
h(a){var t=this,s=t.c,r=s==null?"":" ("+s+")",q=t.d,p=q==null?"":": "+q,o=t.gp()+r+p
if(!t.a)return o
return o+t.gn()+": "+A.ai(t.gt())},
gt(){return this.b}}
A.aj.prototype={
gt(){return this.b},
gp(){return"RangeError"},
gn(){if(this.b<0)return": index must not be negative"
var t=this.f
if(t===0)return": no indices are valid"
return": index should be less than "+t}}
A.as.prototype={
h(a){return"UnimplementedError: "+this.a}}
A.ag.prototype={
h(a){var t=this.a
if(t==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.ai(t)+"."}}
A.M.prototype={
h(a){return"null"}}
A.f.prototype={$if:1,
h(a){return"Instance of '"+A.a8(this)+"'"},
gi(a){return A.cL(this)},
toString(){return this.h(this)}}
A.ap.prototype={
h(a){var t=this.a
return t.charCodeAt(0)==0?t:t}}
A.b.prototype={}
A.V.prototype={
h(a){return String(a)}}
A.W.prototype={
h(a){return String(a)}}
A.F.prototype={}
A.a0.prototype={
h(a){return String(a)}}
A.a.prototype={
h(a){return a.localName}}
A.G.prototype={}
A.u.prototype={
gu(a){return a.length},
v(a,b){var t=a.length
if(b>>>0!==b||b>=t)throw A.j(A.bK(b,t,a,null))
return a[b]},
q(a,b){return a[b]},
$iaI:1}
A.c.prototype={
C(a){var t
while(t=a.firstChild,t!=null)a.removeChild(t)},
h(a){var t=a.nodeValue
return t==null?this.A(a):t},
$ic:1}
A.y.prototype={
gm(a){return new A.a1(a,a.length,A.D(a).l("a1<y.E>"))}}
A.a1.prototype={
k(){var t=this,s=t.c+1,r=t.b
if(s<r){t.d=t.a[s]
t.c=s
return!0}t.d=null
t.c=r
return!1},
gj(){var t=this.d
return t==null?this.$ti.c.a(t):t}}
A.ab.prototype={}
A.ac.prototype={};(function aliases(){var t=J.H.prototype
t.A=t.h
t=J.q.prototype
t.B=t.h})();(function inheritance(){var t=hunkHelpers.mixin,s=hunkHelpers.inherit,r=hunkHelpers.inheritMany
s(A.f,null)
r(A.f,[A.aH,J.H,A.O,J.Y,A.ah,A.a6,A.t,A.n,A.aa,A.av,A.z,A.M,A.ap,A.y,A.a1])
r(J.H,[J.a3,J.I,J.d,J.K,J.L,J.ak,J.J])
r(J.d,[J.q,J.l,A.G,A.a0,A.ab])
r(J.q,[J.a7,J.P,J.p])
s(J.a2,A.O)
s(J.al,J.l)
r(J.ak,[J.a4,J.a5])
r(A.ah,[A.am,A.an,A.at,A.ae,A.ar,A.X,A.as,A.ag])
r(A.t,[A.af,A.aq,A.aC,A.aE])
r(A.aq,[A.ao,A.a_])
s(A.aD,A.af)
s(A.ad,A.at)
s(A.aj,A.X)
s(A.c,A.G)
s(A.a,A.c)
s(A.b,A.a)
r(A.b,[A.V,A.W,A.F])
s(A.ac,A.ab)
s(A.u,A.ac)
t(A.ab,A.z)
t(A.ac,A.y)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{br:"int",bp:"double",bs:"num",a9:"String",bn:"bool",M:"Null",bL:"List",f:"Object",d8:"Map",i:"JSObject"},mangledNames:{},types:[],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.c1(v.typeUniverse,JSON.parse('{"a7":"q","P":"q","p":"q","d9":"a","d0":"b","da":"b","d1":"c","dc":"c","d2":"c","d_":"d","d5":"d","d7":"u","a3":{"o":[]},"I":{"o":[]},"d":{"i":[]},"q":{"i":[]},"l":{"i":[]},"a2":{"O":[]},"al":{"l":["1"],"i":[]},"a4":{"o":[]},"a5":{"o":[]},"J":{"a9":[],"o":[]},"c":{"i":[]},"b":{"c":[],"i":[]},"V":{"c":[],"i":[]},"W":{"c":[],"i":[]},"F":{"c":[],"i":[]},"a0":{"i":[]},"a":{"c":[],"i":[]},"G":{"i":[]},"u":{"z":["c"],"y":["c"],"aI":["c"],"i":[],"z.E":"c","y.E":"c"}}'))
var u=(function rtii(){var t=A.aR
return{Z:t("d6"),s:t("l<a9>"),b:t("l<@>"),T:t("I"),m:t("i"),g:t("p"),p:t("aI<@>"),P:t("M"),K:t("f"),L:t("db"),N:t("a9"),R:t("o"),o:t("P"),y:t("bn"),i:t("bp"),S:t("br"),O:t("b0<M>?"),z:t("i?"),X:t("f?"),v:t("a9?"),u:t("bn?"),I:t("bp?"),t:t("br?"),n:t("bs?"),H:t("bs")}})();(function constants(){B.e=A.F.prototype
B.m=J.H.prototype
B.n=J.p.prototype
B.o=J.d.prototype
B.d=J.a7.prototype
B.a=J.P.prototype
B.b=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.f=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.l=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.h=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.k=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.j=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.i=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.c=function(hooks) { return hooks; }
})();(function staticFields(){$.au=null
$.az=A.ay([],A.aR("l<f>"))
$.aX=null
$.aW=null
$.bq=null
$.bm=null
$.bu=null
$.aA=null
$.aF=null
$.aT=null})();(function lazyInitializers(){var t=hunkHelpers.lazyFinal
t($,"d4","by",()=>A.aB("_$dart_dartClosure"))
t($,"d3","bx",()=>A.aB("_$dart_dartClosure_dartJSInterop"))
t($,"de","bz",()=>A.ay([new J.a2()],A.aR("l<O>")))})();(function nativeSupport(){!function(){var t=function(a){var n={}
n[a]=1
return Object.keys(hunkHelpers.convertToFastObject(n))[0]}
v.getIsolateTag=function(a){return t("___dart_"+a+v.isolateTag)}
var s="___dart_isolate_tags_"
var r=Object[s]||(Object[s]=Object.create(null))
var q="_ZxYxX"
for(var p=0;;p++){var o=t(q+"_"+p+"_")
if(!(o in r)){r[o]=1
v.isolateTag=o
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ApplicationCacheErrorEvent:J.d,DOMError:J.d,DOMTokenList:J.d,ErrorEvent:J.d,Event:J.d,InputEvent:J.d,SubmitEvent:J.d,MediaError:J.d,NavigatorUserMediaError:J.d,OverconstrainedError:J.d,PositionError:J.d,GeolocationPositionError:J.d,SensorErrorEvent:J.d,SpeechRecognitionError:J.d,HTMLAudioElement:A.b,HTMLBRElement:A.b,HTMLBaseElement:A.b,HTMLButtonElement:A.b,HTMLCanvasElement:A.b,HTMLContentElement:A.b,HTMLDListElement:A.b,HTMLDataElement:A.b,HTMLDataListElement:A.b,HTMLDetailsElement:A.b,HTMLDialogElement:A.b,HTMLDivElement:A.b,HTMLEmbedElement:A.b,HTMLFieldSetElement:A.b,HTMLFormElement:A.b,HTMLHRElement:A.b,HTMLHeadElement:A.b,HTMLHeadingElement:A.b,HTMLHtmlElement:A.b,HTMLIFrameElement:A.b,HTMLImageElement:A.b,HTMLInputElement:A.b,HTMLLIElement:A.b,HTMLLabelElement:A.b,HTMLLegendElement:A.b,HTMLLinkElement:A.b,HTMLMapElement:A.b,HTMLMediaElement:A.b,HTMLMenuElement:A.b,HTMLMetaElement:A.b,HTMLMeterElement:A.b,HTMLModElement:A.b,HTMLOListElement:A.b,HTMLObjectElement:A.b,HTMLOptGroupElement:A.b,HTMLOptionElement:A.b,HTMLOutputElement:A.b,HTMLParagraphElement:A.b,HTMLParamElement:A.b,HTMLPictureElement:A.b,HTMLPreElement:A.b,HTMLProgressElement:A.b,HTMLQuoteElement:A.b,HTMLScriptElement:A.b,HTMLSelectElement:A.b,HTMLShadowElement:A.b,HTMLSlotElement:A.b,HTMLSourceElement:A.b,HTMLSpanElement:A.b,HTMLStyleElement:A.b,HTMLTableCaptionElement:A.b,HTMLTableCellElement:A.b,HTMLTableDataCellElement:A.b,HTMLTableHeaderCellElement:A.b,HTMLTableColElement:A.b,HTMLTableElement:A.b,HTMLTableRowElement:A.b,HTMLTableSectionElement:A.b,HTMLTemplateElement:A.b,HTMLTextAreaElement:A.b,HTMLTimeElement:A.b,HTMLTitleElement:A.b,HTMLTrackElement:A.b,HTMLUListElement:A.b,HTMLUnknownElement:A.b,HTMLVideoElement:A.b,HTMLDirectoryElement:A.b,HTMLFontElement:A.b,HTMLFrameElement:A.b,HTMLFrameSetElement:A.b,HTMLMarqueeElement:A.b,HTMLElement:A.b,HTMLAnchorElement:A.V,HTMLAreaElement:A.W,HTMLBodyElement:A.F,DOMException:A.a0,MathMLElement:A.a,SVGAElement:A.a,SVGAnimateElement:A.a,SVGAnimateMotionElement:A.a,SVGAnimateTransformElement:A.a,SVGAnimationElement:A.a,SVGCircleElement:A.a,SVGClipPathElement:A.a,SVGDefsElement:A.a,SVGDescElement:A.a,SVGDiscardElement:A.a,SVGEllipseElement:A.a,SVGFEBlendElement:A.a,SVGFEColorMatrixElement:A.a,SVGFEComponentTransferElement:A.a,SVGFECompositeElement:A.a,SVGFEConvolveMatrixElement:A.a,SVGFEDiffuseLightingElement:A.a,SVGFEDisplacementMapElement:A.a,SVGFEDistantLightElement:A.a,SVGFEFloodElement:A.a,SVGFEFuncAElement:A.a,SVGFEFuncBElement:A.a,SVGFEFuncGElement:A.a,SVGFEFuncRElement:A.a,SVGFEGaussianBlurElement:A.a,SVGFEImageElement:A.a,SVGFEMergeElement:A.a,SVGFEMergeNodeElement:A.a,SVGFEMorphologyElement:A.a,SVGFEOffsetElement:A.a,SVGFEPointLightElement:A.a,SVGFESpecularLightingElement:A.a,SVGFESpotLightElement:A.a,SVGFETileElement:A.a,SVGFETurbulenceElement:A.a,SVGFilterElement:A.a,SVGForeignObjectElement:A.a,SVGGElement:A.a,SVGGeometryElement:A.a,SVGGraphicsElement:A.a,SVGImageElement:A.a,SVGLineElement:A.a,SVGLinearGradientElement:A.a,SVGMarkerElement:A.a,SVGMaskElement:A.a,SVGMetadataElement:A.a,SVGPathElement:A.a,SVGPatternElement:A.a,SVGPolygonElement:A.a,SVGPolylineElement:A.a,SVGRadialGradientElement:A.a,SVGRectElement:A.a,SVGScriptElement:A.a,SVGSetElement:A.a,SVGStopElement:A.a,SVGStyleElement:A.a,SVGElement:A.a,SVGSVGElement:A.a,SVGSwitchElement:A.a,SVGSymbolElement:A.a,SVGTSpanElement:A.a,SVGTextContentElement:A.a,SVGTextElement:A.a,SVGTextPathElement:A.a,SVGTextPositioningElement:A.a,SVGTitleElement:A.a,SVGUseElement:A.a,SVGViewElement:A.a,SVGGradientElement:A.a,SVGComponentTransferFunctionElement:A.a,SVGFEDropShadowElement:A.a,SVGMPathElement:A.a,Element:A.a,EventTarget:A.G,HTMLCollection:A.u,HTMLFormControlsCollection:A.u,HTMLOptionsCollection:A.u,CDATASection:A.c,CharacterData:A.c,Comment:A.c,Document:A.c,DocumentFragment:A.c,HTMLDocument:A.c,ProcessingInstruction:A.c,ShadowRoot:A.c,Text:A.c,XMLDocument:A.c,Attr:A.c,DocumentType:A.c,Node:A.c})
hunkHelpers.setOrUpdateLeafTags({ApplicationCacheErrorEvent:true,DOMError:true,DOMTokenList:true,ErrorEvent:true,Event:true,InputEvent:true,SubmitEvent:true,MediaError:true,NavigatorUserMediaError:true,OverconstrainedError:true,PositionError:true,GeolocationPositionError:true,SensorErrorEvent:true,SpeechRecognitionError:true,HTMLAudioElement:true,HTMLBRElement:true,HTMLBaseElement:true,HTMLButtonElement:true,HTMLCanvasElement:true,HTMLContentElement:true,HTMLDListElement:true,HTMLDataElement:true,HTMLDataListElement:true,HTMLDetailsElement:true,HTMLDialogElement:true,HTMLDivElement:true,HTMLEmbedElement:true,HTMLFieldSetElement:true,HTMLFormElement:true,HTMLHRElement:true,HTMLHeadElement:true,HTMLHeadingElement:true,HTMLHtmlElement:true,HTMLIFrameElement:true,HTMLImageElement:true,HTMLInputElement:true,HTMLLIElement:true,HTMLLabelElement:true,HTMLLegendElement:true,HTMLLinkElement:true,HTMLMapElement:true,HTMLMediaElement:true,HTMLMenuElement:true,HTMLMetaElement:true,HTMLMeterElement:true,HTMLModElement:true,HTMLOListElement:true,HTMLObjectElement:true,HTMLOptGroupElement:true,HTMLOptionElement:true,HTMLOutputElement:true,HTMLParagraphElement:true,HTMLParamElement:true,HTMLPictureElement:true,HTMLPreElement:true,HTMLProgressElement:true,HTMLQuoteElement:true,HTMLScriptElement:true,HTMLSelectElement:true,HTMLShadowElement:true,HTMLSlotElement:true,HTMLSourceElement:true,HTMLSpanElement:true,HTMLStyleElement:true,HTMLTableCaptionElement:true,HTMLTableCellElement:true,HTMLTableDataCellElement:true,HTMLTableHeaderCellElement:true,HTMLTableColElement:true,HTMLTableElement:true,HTMLTableRowElement:true,HTMLTableSectionElement:true,HTMLTemplateElement:true,HTMLTextAreaElement:true,HTMLTimeElement:true,HTMLTitleElement:true,HTMLTrackElement:true,HTMLUListElement:true,HTMLUnknownElement:true,HTMLVideoElement:true,HTMLDirectoryElement:true,HTMLFontElement:true,HTMLFrameElement:true,HTMLFrameSetElement:true,HTMLMarqueeElement:true,HTMLElement:false,HTMLAnchorElement:true,HTMLAreaElement:true,HTMLBodyElement:true,DOMException:true,MathMLElement:true,SVGAElement:true,SVGAnimateElement:true,SVGAnimateMotionElement:true,SVGAnimateTransformElement:true,SVGAnimationElement:true,SVGCircleElement:true,SVGClipPathElement:true,SVGDefsElement:true,SVGDescElement:true,SVGDiscardElement:true,SVGEllipseElement:true,SVGFEBlendElement:true,SVGFEColorMatrixElement:true,SVGFEComponentTransferElement:true,SVGFECompositeElement:true,SVGFEConvolveMatrixElement:true,SVGFEDiffuseLightingElement:true,SVGFEDisplacementMapElement:true,SVGFEDistantLightElement:true,SVGFEFloodElement:true,SVGFEFuncAElement:true,SVGFEFuncBElement:true,SVGFEFuncGElement:true,SVGFEFuncRElement:true,SVGFEGaussianBlurElement:true,SVGFEImageElement:true,SVGFEMergeElement:true,SVGFEMergeNodeElement:true,SVGFEMorphologyElement:true,SVGFEOffsetElement:true,SVGFEPointLightElement:true,SVGFESpecularLightingElement:true,SVGFESpotLightElement:true,SVGFETileElement:true,SVGFETurbulenceElement:true,SVGFilterElement:true,SVGForeignObjectElement:true,SVGGElement:true,SVGGeometryElement:true,SVGGraphicsElement:true,SVGImageElement:true,SVGLineElement:true,SVGLinearGradientElement:true,SVGMarkerElement:true,SVGMaskElement:true,SVGMetadataElement:true,SVGPathElement:true,SVGPatternElement:true,SVGPolygonElement:true,SVGPolylineElement:true,SVGRadialGradientElement:true,SVGRectElement:true,SVGScriptElement:true,SVGSetElement:true,SVGStopElement:true,SVGStyleElement:true,SVGElement:true,SVGSVGElement:true,SVGSwitchElement:true,SVGSymbolElement:true,SVGTSpanElement:true,SVGTextContentElement:true,SVGTextElement:true,SVGTextPathElement:true,SVGTextPositioningElement:true,SVGTitleElement:true,SVGUseElement:true,SVGViewElement:true,SVGGradientElement:true,SVGComponentTransferFunctionElement:true,SVGFEDropShadowElement:true,SVGMPathElement:true,Element:false,EventTarget:false,HTMLCollection:true,HTMLFormControlsCollection:true,HTMLOptionsCollection:true,CDATASection:true,CharacterData:true,Comment:true,Document:true,DocumentFragment:true,HTMLDocument:true,ProcessingInstruction:true,ShadowRoot:true,Text:true,XMLDocument:true,Attr:true,DocumentType:true,Node:false})})()
Function.prototype.$0=function(){return this()}
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$2=function(a,b){return this(a,b)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var t=document.scripts
function onLoad(b){for(var r=0;r<t.length;++r){t[r].removeEventListener("load",onLoad,false)}a(b.target)}for(var s=0;s<t.length;++s){t[s].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var t=A.cU
if(typeof dartMainRunner==="function"){dartMainRunner(t,[])}else{t([])}})})()
//# sourceMappingURL=main.dart.js.map
