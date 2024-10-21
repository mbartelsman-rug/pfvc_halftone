var I=Object.defineProperty;var H=(t,e,n)=>e in t?I(t,e,{enumerable:!0,configurable:!0,writable:!0,value:n}):t[e]=n;var a=(t,e,n)=>H(t,typeof e!="symbol"?e+"":e,n);(function(){const e=document.createElement("link").relList;if(e&&e.supports&&e.supports("modulepreload"))return;for(const r of document.querySelectorAll('link[rel="modulepreload"]'))s(r);new MutationObserver(r=>{for(const o of r)if(o.type==="childList")for(const c of o.addedNodes)c.tagName==="LINK"&&c.rel==="modulepreload"&&s(c)}).observe(document,{childList:!0,subtree:!0});function n(r){const o={};return r.integrity&&(o.integrity=r.integrity),r.referrerPolicy&&(o.referrerPolicy=r.referrerPolicy),r.crossOrigin==="use-credentials"?o.credentials="include":r.crossOrigin==="anonymous"?o.credentials="omit":o.credentials="same-origin",o}function s(r){if(r.ep)return;r.ep=!0;const o=n(r);fetch(r.href,o)}})();const M=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1 class="display-1">Welcome</h1>\r
            <p>In this experiment you will be presented with a series of tasks. For each task you will be presented with a grayscale image for you to familiarize yourself with. Afterwards, you will be presented with two variant images in pixelated black and white. You must choose one of the two based on the following criteria:</p>\r
            <ul>\r
                <li>The image that most closely resembles the original.</li>\r
                <li>The image that best preserves details.</li>\r
                <li>The image that best preserves textures.</li>\r
                <li>The image with least artifacts or confusing patterns.</li>\r
            </ul>\r
            <p>After each task you will see a cooldown screen where you must wait for a bit. This is to help your eyes rest between each task.</p>\r
            <p>You can advance by pressing the "Next" button at the bottom or the <kbd>S</kbd> key. You can choose an image by pressing on it or with the <kbd>A</kbd> and <kbd>S</kbd> keys respectively. If you must conclude the experiment early, you can press <kbd>Esc</kbd> to skip to the end, where you can get the results to send them my way.</p>\r
            <p>Before you start, it's important for you to calibrate your display</p>\r
        </article>\r
    <!-- </div> -->\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,q=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1>Display calibration</h1>\r
            <p>Before you start, you must make sure your display gamma is calibrated. This is not a permanent change unless you wish it so.</p>\r
            <p>To do this on Windows, press "Start" and search for "Calibrate display color". This will open an assistant tool that will walk you through the process. The first part of this process is the gamma calibration. After calibrating the gamma, there's a brightness/contrast step and a color calibration step, you may skip these.</p>\r
            <p>If you don't want to change your display settings permanently, all you need to do is (1) select "current calibration", (2) run the experiment, and (3) cancel the calibration.</p>\r
            <div style="text-align: center;">\r
                <img src="./public/img/calibrate.png">\r
            </div>\r
        </article>\r
    <!-- </div> -->\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,E=`<div id="tasks" class="choice">\r
    <img id="show-img" src="#">\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,W=`<div id="tasks" class="choice">\r
    <div id="left-container" class="image-container unmarked-choice"><img id="left-img" src="#"></div>\r
    <div id="right-container" class="image-container unmarked-choice"><img id="right-img" src="#"></div>\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,A=`<div id="tasks">\r
    <article>\r
        <p id="countdown"></p>\r
    </article>\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,R=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1>Experiment results</h1>\r
            <p>Copy the text below to share the results of the experiment.</p>\r
            <textarea id="results" readonly value="Loading results...">\r
        </article>\r
    <!-- </div> -->\r
</div>`;var l=(t=>(t[t.Left=0]="Left",t[t.Right=1]="Right",t))(l||{});class b{toString(){return"IntroTask()"}}class x{toString(){return"CalibrateTask()"}}class p{constructor(e){a(this,"id");this.id=e}toString(){return"ShowTask("+this.id+")"}}class y{constructor(e,n,s){a(this,"id");a(this,"left");a(this,"right");a(this,"choice");this.id=e,this.left=n,this.right=s,this.choice=null}choose(e){this.choice=e}toString(){return"ChoiceTask("+this.id+"/"+this.left+" or "+this.id+"/"+this.right+")"}}class g{constructor(e){a(this,"started",!1);a(this,"remaining",3e3);this.remaining=e}start(){this.started=!0;let e=this,n=setInterval(()=>{document.hasFocus()&&(e.remaining-=250)},250);setTimeout(()=>{clearInterval(n)},this.remaining+500)}clear(){this.remaining=0,this.started=!0}get isReady(){return this.remaining<=0}toString(){return"WaitTask("+(this.started?"[counting] ":"[paused] ")+String(this.remaining)+"ms)"}}class S{toString(){return"GoodbyeTask()"}}class _{constructor(e){a(this,"taskIndex",0);a(this,"tasks");a(this,"earlyTermination",!1);const n=e.trials||0,s=(e.algorithms||[]).filter(o=>o.enabled),r=e.images||[];this.tasks=[],this.tasks.push(new b),this.tasks.push(new x);for(const o of Array(n).keys()){const c=w(1,r)[0],[v,u]=w(2,s);this.tasks.push(new p(c)),this.tasks.push(new y(c,v.id,u.id)),o<n-1&&this.tasks.push(new g(e.wait_ms))}this.tasks.push(new S),this.logNextTask()}get currentTask(){return this.tasks[this.taskIndex]}get hasNext(){return this.taskIndex<this.tasks.length-1}get canAdvance(){return this.currentTask instanceof g?(console.log(this.currentTask.remaining),console.log(this.currentTask.started),this.hasNext&&this.currentTask.isReady):this.currentTask instanceof y?this.hasNext&&this.currentTask.choice!=null:this.hasNext}nextTask(){return this.canAdvance?(this.taskIndex+=1,this.logNextTask(),this.currentTask instanceof g&&this.currentTask.start(),!0):!1}terminate(){this.taskIndex=this.tasks.length-1,this.earlyTermination=!0}logNextTask(){console.log("Starting task "+String(this.taskIndex)+"/"+this.tasks.length+": "+this.currentTask.toString())}}function w(t,e){let n=[...Array(e.length).keys()],s=n.length;for(;s!=0;){let o=Math.floor(Math.random()*s);s--,[n[s],n[o]]=[n[o],n[s]]}return n.slice(0,t).map(o=>e[o])}function k(t){if(t==null){console.error("'task' is null");return}t instanceof b&&C(),t instanceof x&&F(),t instanceof p&&O(t),t instanceof y&&K(t),t instanceof g&&z(t),t instanceof S&&P(),N()}function C(t){h().innerHTML=M,d(f())}function F(t){h().innerHTML=q,d(f())}function O(t){h().innerHTML=E,B(t),d(f())}function K(t){h().innerHTML=W,G(t),d(f())}function z(t){h().innerHTML=A,Y(t),d(f())}function P(t){h().innerHTML=R,j(),d(f()),console.log(i)}function B(t){let e=document.querySelector("#show-img");if(e==null){console.error("'img' is null");return}e.src="./public/img/"+t.id+"/base.png"}function G(t){let e=document.querySelector("#left-img"),n=document.querySelector("#right-img");if(e==null){console.error("'left' is null");return}if(n==null){console.error("'right' is null");return}e.addEventListener("click",s=>{m(l.Left)}),n.addEventListener("click",s=>{m(l.Right)}),e.src="./public/img/"+t.id+"/"+t.left+".png",n.src="./public/img/"+t.id+"/"+t.right+".png"}function m(t){if(!((i==null?void 0:i.currentTask)instanceof y))return;let e=document.querySelector("#left-container"),n=document.querySelector("#right-container");e.classList.remove("unmarked-choice","other-choice","selected-choice"),n.classList.remove("unmarked-choice","other-choice","selected-choice"),t===null&&(e.classList.add("unmarked-choice"),n.classList.add("unmarked-choice")),t===l.Left&&(e.classList.add("selected-choice"),n.classList.add("other-choice")),t===l.Right&&(e.classList.add("other-choice"),n.classList.add("selected-choice")),i.currentTask.choose(t)}function Y(t){const e=document.querySelector("#countdown");if(e==null){console.error("'countdown' is null");return}let n=!0;const s=setInterval(()=>{document.hasFocus()&&(t.remaining>0?e.innerText="Please wait "+String(Math.round(t.remaining/100)/10)+" seconds...":(n&&(n=!1,i.nextTask(),k(i.currentTask)),e.innerText="You may continue now."))},50);setTimeout(()=>{clearInterval(s)},t.remaining+500)}function j(t){const e=document.querySelector("#results");if(e==null){console.error("'results' is null");return}e.value=JSON.stringify(i)}function D(t){L()}function L(){if(i==null){console.error("'experiment' is null");return}i.nextTask()&&k(i.currentTask)}function U(){if(i==null){console.error("'experiment' is null");return}i.terminate(),k(i.currentTask)}function J(t){if(t==null){console.error("'element' is null");return}let e=i==null?void 0:i.tasks.slice(0,(i==null?void 0:i.taskIndex)+1).filter(s=>s instanceof p).length,n=i==null?void 0:i.tasks.filter(s=>s instanceof p).length;t.innerHTML="Next ("+String(e)+"/"+String(n)+")",t.addEventListener("click",D)}function d(t){if(t==null){console.error("'element' is null");return}J(t.querySelector("#next-task"))}function Q(t){t==="KeyS"&&L(),t==="KeyA"&&m(l.Left),t==="KeyD"&&m(l.Right),t==="KeyW"&&m(null),t==="Escape"&&U()}function N(){const t=document.querySelector("#navigation"),n=document.querySelector("#tasks").getElementsByTagName("img"),s=window.innerWidth,r=window.innerHeight-t.offsetHeight+100,o=Math.min(s,r),c=Math.max(s,r),u=Math.min(o,c/2.2)/1e3;for(const T of n)u<1?T.style.maxWidth=String(1e3/Math.pow(2,Math.ceil(Math.log2(1/u))))+"px":T.style.maxWidth=String(1e3*Math.floor(u)/2)+"px";console.log("Resized = ["+s+", "+r+"], Factor = "+u)}function V(t){Q(t.code)}function X(t){N()}function Z(t){(i==null?void 0:i.currentTask)instanceof g&&(i==null||i.currentTask.clear(),k(i.currentTask))}let i=null,h=()=>document.querySelector("#experiment"),f=()=>document.querySelector("#navigation");async function $(){i=await fetch("src/data/configuration.json").then(t=>t.json()).then(t=>t).then(t=>new _(t)).catch(t=>(console.error("Could not fetch configuration"),null)),document.addEventListener("keyup",V),window.addEventListener("resize",X),window.addEventListener("focus",Z),k((i==null?void 0:i.currentTask)||null)}(async()=>$())();
