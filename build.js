!function n(t,r,e){function u(f,o){if(!r[f]){if(!t[f]){var i="function"==typeof require&&require;if(!o&&i)return i(f,!0);if(l)return l(f,!0);var a=new Error("Cannot find module '"+f+"'");throw a.code="MODULE_NOT_FOUND",a}var c=r[f]={exports:{}};t[f][0].call(c.exports,function(n){var r=t[f][1][n];return u(r?r:n)},c,c.exports,n,t,r,e)}return r[f].exports}for(var l="function"==typeof require&&require,f=0;f<e.length;f++)u(e[f]);return u}({1:[function(){var n,t,r,e,u,l,f,o,i,a,c,h,v,s,d,p,g,m,M,q,x,y,w,C,D,E,O,F,X,Y,b,k,A,H,L,N,R,U,W,_,B,S,T,j,z=[].indexOf||function(n){for(var t=0,r=this.length;r>t;t++)if(t in this&&this[t]===n)return t;return-1};L=function(n,t){return Math.floor(n+Math.random()*(t-n+1))},A=function(n){return n[L(0,n.length-1)]},E=function(n,t){return n%t},F=function(n,t){return Math.floor(n/t)},O=function(n,t,r){return t*r+n},X=function(n,t,r){var e,u,l,f,o,i,a,c;if(f=0,u=n.length,o=E(t,r),i=F(t,r),l=o-1,l>=0&&r>l)for(e=a=l;(0>=l?0>=a:a>=0)&&n[i*r+e]===n[t];e=0>=l?++a:--a)f+=1;if(l=o+1,l>=0&&r>l)for(e=c=l;(r>=l?r>c:c>r)&&u>i*r+l&&n[i*r+e]===n[t];e=r>=l?++c:--c)f+=1;return f>=2},T=function(n,t,r,e){var u,l,f,o,i,a,c,h;if(o=0,l=n.length,i=E(t,r),a=F(t,r),f=a-1,a>=0&&e>a)for(u=c=f;(0>=f?0>=c:c>=0)&&n[u*r+i]===n[t];u=0>=f?++c:--c)o+=1;if(f=a+1,a>=0&&e>a)for(u=h=f;(e>=f?e>h:h>e)&&l>f*r+i&&n[u*r+i]===n[t];u=e>=f?++h:--h)o+=1;return o>=2},b=function(n,t,r,e){var u,l;return u=X(n,t,r),l=T(n,t,r,e),u||l},g=function(n,t,r){var e,u,l,f,o,i,a,c;return e=E(n,r),l=F(n,r),u=E(t,r),f=F(t,r),z.call(function(){a=[];for(var n=o=u-1,t=u+1;t>=o?t>=n:n>=t;t>=o?n++:n--)a.push(n);return a}.apply(this),e)<0?!1:z.call(function(){c=[];for(var n=i=f-1,t=f+1;t>=i?t>=n:n>=t;t>=i?n++:n--)c.push(n);return c}.apply(this),l)<0?!1:e!==u&&l!==f?!1:!0},w=function(n,t,r,e,u){var l,f,o,i,a,c,h,v,s;for(null==u&&(u={}),f=u.offsetX,o=u.offsetY,a=u.tileWidth,i=u.tileHeight,null==f&&(f=0),null==o&&(o=0),null==a&&(a=32),null==i&&(i=32),s=[],l=c=0,h=n.length;h>=0?h>=c:c>=h;l=h>=0?++c:--c)r.fillStyle=null!=(v=e[n[l]])?v:"#000",s.push(r.fillRect(f+E(l,t)*a,o+F(l,t)*i,a,i));return s},i=2,p=320*i,o=480*i,f=60,a=10,e=8,s=32*i,v=32*i,t=s,r=4*v,j=[0,1,2,3],n=j[0],u=j[1],l=j[2],d=j[3],h=j,c=["#fff","#855","#f00","#00f"],q=document.createElement("canvas"),q.width=p,q.height=o,y=q.getContext("2d"),x=null,document.body.appendChild(q),D=function(n,t,r){var e,u,l,f;for(l=n*t,e=[],u=f=0;l>=0?l>f:f>l;u=l>=0?++f:--f)for(;;)if(e[u]=A(r),!b(e,u,n,t))break;return e},N={offsetX:t,offsetY:r,tileWidth:s,tileHeight:v},_=null,B=null,U=function(n,t,r){var e;return e=[n[r],n[t]],n[t]=e[0],n[r]=e[1],e},q.addEventListener("click",function(n){var u,l,f,o,i,c,d,p,M;return null==x&&(x=q.getBoundingClientRect()),u=n.clientX-x.left,l=n.clientY-x.top,c=Math.floor((u-t)/s),d=Math.floor((l-r)/v),c>=0&&e>c&&d>=0&&a>d&&(o=O(c,d,e),null===_?_=o:B=o,null!=_&&null!=B)?(p=m[_],z.call(h,p)>=0&&(M=m[B],z.call(h,M)>=0)&&g(_,B,e)&&(U(m,_,B),f=b(m,_,e,a),i=b(m,B,e,a),f||i||U(m,_,B)),_=B=null):void 0}),m=D(e,a,h),M=function(n,t,r,e){var u,l,f,o,i,a,c,h,v;for(u=i=c=n.length-1;0>=c?0>=i:i>=0;u=0>=c?++i:--i)null===n[u]&&(f=E(u,t),o=F(u,t),l=(o-1)*t+f,l>=0&&l<n.length&&U(n,u,l));for(v=[],u=a=0,h=n.length;h>=0?h>a:a>h;u=h>=0?++a:--a)null===n[u]?v.push(n[u]=A(e)):v.push(void 0);return v},S=function(){var n,t,r,u,l,f;for(t=[],n=r=0,f=m.length;f>=0?f>r:r>f;n=f>=0?++r:--r)b(m,n,e,a)&&t.push(n);for(u=0,l=t.length;l>u;u++)n=t[u],m[n]=null;return M(m,e,a,h)},R=1/f,k=1,Y=R*k,C=0,H=new Date,requestAnimationFrame(W=function(){var n;for(n=new Date,C+=Math.min(1,(n-H)/1e3),H=n;C>Y;)S(R),C-=Y;return w(m,e,y,c,N),requestAnimationFrame(W)})},{}]},{},[1]);