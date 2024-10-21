var I=Object.defineProperty;var M=(t,e,n)=>e in t?I(t,e,{enumerable:!0,configurable:!0,writable:!0,value:n}):t[e]=n;var a=(t,e,n)=>M(t,typeof e!="symbol"?e+"":e,n);(function(){const e=document.createElement("link").relList;if(e&&e.supports&&e.supports("modulepreload"))return;for(const s of document.querySelectorAll('link[rel="modulepreload"]'))i(s);new MutationObserver(s=>{for(const o of s)if(o.type==="childList")for(const l of o.addedNodes)l.tagName==="LINK"&&l.rel==="modulepreload"&&i(l)}).observe(document,{childList:!0,subtree:!0});function n(s){const o={};return s.integrity&&(o.integrity=s.integrity),s.referrerPolicy&&(o.referrerPolicy=s.referrerPolicy),s.crossOrigin==="use-credentials"?o.credentials="include":s.crossOrigin==="anonymous"?o.credentials="omit":o.credentials="same-origin",o}function i(s){if(s.ep)return;s.ep=!0;const o=n(s);fetch(s.href,o)}})();const H=`<div id="tasks">\r
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
</div>`,F=`<div id="tasks" class="choice">\r
    <div id="left-container" class="image-container unmarked-choice"><img id="left-img" src="#"></div>\r
    <div id="right-container" class="image-container unmarked-choice"><img id="right-img" src="#"></div>\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,W=`<div id="tasks">\r
    <article>\r
        <p id="countdown"></p>\r
    </article>\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,A=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1>Experiment results</h1>\r
            <p>Copy the text below to share the results of the experiment.</p>\r
            <textarea id="results" readonly value="Loading results...">\r
        </article>\r
    <!-- </div> -->\r
</div>`,R=`{\r
    "trials": 100,\r
    "wait_ms": 2000,\r
    "algorithms": [\r
        {\r
            "id": "fs",\r
            "name": "Floyd-Steinberg",\r
            "enabled": true\r
        },\r
        {\r
            "id": "fs-em",\r
            "name": "Floyd-Steinberg (ECTM)",\r
            "enabled": true\r
        },\r
        {\r
            "id": "o",\r
            "name": "Ostromoukhov",\r
            "enabled": false\r
        },\r
        {\r
            "id": "zf",\r
            "name": "Zhou-Fang",\r
            "enabled": true\r
        },\r
        {\r
            "id": "zf-em",\r
            "name": "Zhou-Fang (ECTM)",\r
            "enabled": true\r
        },\r
        {\r
            "id": "x",\r
            "name": "Xiangyu",\r
            "enabled": true\r
        }\r
    ],\r
    "images": [\r
        "bedouin",\r
        "botanic",\r
        "calanque",\r
        "calculator",\r
        "carceri",\r
        "cd",\r
        "conch",\r
        "crypt",\r
        "ernte",\r
        "espinasse",\r
        "imaginary",\r
        "lines",\r
        "owls",\r
        "renoir",\r
        "sagarmatha",\r
        "snow",\r
        "text",\r
        "trefoil"\r
    ]\r
}`;var c=(t=>(t[t.Left=0]="Left",t[t.Right=1]="Right",t))(c||{});class w{toString(){return"IntroTask()"}}class x{toString(){return"CalibrateTask()"}}class k{constructor(e){a(this,"id");this.id=e}toString(){return"ShowTask("+this.id+")"}}class p{constructor(e,n,i){a(this,"id");a(this,"left");a(this,"right");a(this,"choice");this.id=e,this.left=n,this.right=i,this.choice=null}choose(e){this.choice=e}toString(){return"ChoiceTask("+this.id+"/"+this.left+" or "+this.id+"/"+this.right+")"}}class g{constructor(e){a(this,"started",!1);a(this,"remaining",3e3);this.remaining=e}start(){this.started=!0;let e=this,n=setInterval(()=>{document.hasFocus()&&(e.remaining-=250)},250);setTimeout(()=>{clearInterval(n)},this.remaining+500)}clear(){this.remaining=0,this.started=!0}get isReady(){return this.remaining<=0}toString(){return"WaitTask("+(this.started?"[counting] ":"[paused] ")+String(this.remaining)+"ms)"}}class S{toString(){return"GoodbyeTask()"}}class _{constructor(e){a(this,"taskIndex",0);a(this,"tasks");a(this,"earlyTermination",!1);const n=e.trials||0,i=(e.algorithms||[]).filter(o=>o.enabled),s=e.images||[];this.tasks=[],this.tasks.push(new w),this.tasks.push(new x);for(const o of Array(n).keys()){const l=T(1,s)[0],[v,u]=T(2,i);this.tasks.push(new k(l)),this.tasks.push(new p(l,v.id,u.id)),o<n-1&&this.tasks.push(new g(e.wait_ms))}this.tasks.push(new S),this.logNextTask()}get currentTask(){return this.tasks[this.taskIndex]}get hasNext(){return this.taskIndex<this.tasks.length-1}get canAdvance(){return this.currentTask instanceof g?(console.log(this.currentTask.remaining),console.log(this.currentTask.started),this.hasNext&&this.currentTask.isReady):this.currentTask instanceof p?this.hasNext&&this.currentTask.choice!=null:this.hasNext}nextTask(){return this.canAdvance?(this.taskIndex+=1,this.logNextTask(),this.currentTask instanceof g&&this.currentTask.start(),!0):!1}terminate(){this.taskIndex=this.tasks.length-1,this.earlyTermination=!0}logNextTask(){console.log("Starting task "+String(this.taskIndex)+"/"+this.tasks.length+": "+this.currentTask.toString())}}function T(t,e){let n=[...Array(e.length).keys()],i=n.length;for(;i!=0;){let o=Math.floor(Math.random()*i);i--,[n[i],n[o]]=[n[o],n[i]]}return n.slice(0,t).map(o=>e[o])}function y(t){if(t==null){console.error("'task' is null");return}t instanceof w&&C(),t instanceof x&&O(),t instanceof k&&z(t),t instanceof p&&K(t),t instanceof g&&P(t),t instanceof S&&B(),N()}function C(t){h().innerHTML=H,d(f())}function O(t){h().innerHTML=q,d(f())}function z(t){h().innerHTML=E,G(t),d(f())}function K(t){h().innerHTML=F,Y(t),d(f())}function P(t){h().innerHTML=W,J(t),d(f())}function B(t){h().innerHTML=A,D(),d(f()),console.log(r)}function G(t){let e=document.querySelector("#show-img");if(e==null){console.error("'img' is null");return}e.src="./img/"+t.id+"/base.png"}function Y(t){let e=document.querySelector("#left-img"),n=document.querySelector("#right-img");if(e==null){console.error("'left' is null");return}if(n==null){console.error("'right' is null");return}e.addEventListener("click",i=>{m(c.Left)}),n.addEventListener("click",i=>{m(c.Right)}),e.src="./img/"+t.id+"/"+t.left+".png",n.src="./img/"+t.id+"/"+t.right+".png"}function m(t){if(!((r==null?void 0:r.currentTask)instanceof p))return;let e=document.querySelector("#left-container"),n=document.querySelector("#right-container");e.classList.remove("unmarked-choice","other-choice","selected-choice"),n.classList.remove("unmarked-choice","other-choice","selected-choice"),t===null&&(e.classList.add("unmarked-choice"),n.classList.add("unmarked-choice")),t===c.Left&&(e.classList.add("selected-choice"),n.classList.add("other-choice")),t===c.Right&&(e.classList.add("other-choice"),n.classList.add("selected-choice")),r.currentTask.choose(t)}function J(t){const e=document.querySelector("#countdown");if(e==null){console.error("'countdown' is null");return}let n=!0;const i=setInterval(()=>{document.hasFocus()&&(t.remaining>0?e.innerText="Please wait "+String(Math.round(t.remaining/100)/10)+" seconds...":(n&&(n=!1,r.nextTask(),y(r.currentTask)),e.innerText="You may continue now."))},50);setTimeout(()=>{clearInterval(i)},t.remaining+500)}function D(t){const e=document.querySelector("#results");if(e==null){console.error("'results' is null");return}e.value=JSON.stringify(r)}function U(t){L()}function L(){if(r==null){console.error("'experiment' is null");return}r.nextTask()&&y(r.currentTask)}function Z(){if(r==null){console.error("'experiment' is null");return}r.terminate(),y(r.currentTask)}function X(t){if(t==null){console.error("'element' is null");return}let e=r==null?void 0:r.tasks.slice(0,(r==null?void 0:r.taskIndex)+1).filter(i=>i instanceof k).length,n=r==null?void 0:r.tasks.filter(i=>i instanceof k).length;t.innerHTML="Next ("+String(e)+"/"+String(n)+")",t.addEventListener("click",U)}function d(t){if(t==null){console.error("'element' is null");return}X(t.querySelector("#next-task"))}function j(t){t==="KeyS"&&L(),t==="KeyA"&&m(c.Left),t==="KeyD"&&m(c.Right),t==="KeyW"&&m(null),t==="Escape"&&Z()}function N(){const t=document.querySelector("#navigation"),n=document.querySelector("#tasks").getElementsByTagName("img"),i=window.innerWidth,s=window.innerHeight-t.offsetHeight+100,o=Math.min(i,s),l=Math.max(i,s),u=Math.min(o,l/2.2)/1e3;for(const b of n)u<1?b.style.maxWidth=String(1e3/Math.pow(2,Math.ceil(Math.log2(1/u))))+"px":b.style.maxWidth=String(1e3*Math.floor(u)/2)+"px";console.log("Resized = ["+i+", "+s+"], Factor = "+u)}function Q(t){j(t.code)}function V(t){N()}function $(t){(r==null?void 0:r.currentTask)instanceof g&&(r==null||r.currentTask.clear(),y(r.currentTask))}let h=()=>document.querySelector("#experiment"),f=()=>document.querySelector("#navigation"),r=new _(JSON.parse(R));document.addEventListener("keyup",Q);window.addEventListener("resize",V);window.addEventListener("focus",$);y((r==null?void 0:r.currentTask)||null);
