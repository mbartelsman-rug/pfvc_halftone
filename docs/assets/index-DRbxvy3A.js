var H=Object.defineProperty;var q=(t,e,n)=>e in t?H(t,e,{enumerable:!0,configurable:!0,writable:!0,value:n}):t[e]=n;var o=(t,e,n)=>q(t,typeof e!="symbol"?e+"":e,n);(function(){const e=document.createElement("link").relList;if(e&&e.supports&&e.supports("modulepreload"))return;for(const s of document.querySelectorAll('link[rel="modulepreload"]'))i(s);new MutationObserver(s=>{for(const a of s)if(a.type==="childList")for(const c of a.addedNodes)c.tagName==="LINK"&&c.rel==="modulepreload"&&i(c)}).observe(document,{childList:!0,subtree:!0});function n(s){const a={};return s.integrity&&(a.integrity=s.integrity),s.referrerPolicy&&(a.referrerPolicy=s.referrerPolicy),s.crossOrigin==="use-credentials"?a.credentials="include":s.crossOrigin==="anonymous"?a.credentials="omit":a.credentials="same-origin",a}function i(s){if(s.ep)return;s.ep=!0;const a=n(s);fetch(s.href,a)}})();const E=`<div id="tasks">\r
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
            <p>You can advance by pressing the "Next" button at the bottom or the <kbd>S</kbd> key. You can choose an image by pressing on it or with the <kbd>A</kbd> and <kbd>S</kbd> keys. If you must conclude the experiment early, you can press <kbd>Esc</kbd> to skip to the end, where you can get the results to send them my way.</p>\r
            <p>Before you start, it's important for you to calibrate your display</p>\r
        </article>\r
    <!-- </div> -->\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,C=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1>Display calibration</h1>\r
            <p>Before you start, you must make sure your display gamma is calibrated. This is not a permanent change unless you wish it so.</p>\r
            <p>To do this on Windows, press "Start" and search for "Calibrate display color". This will open an assistant tool that will walk you through the process. The first part of this process is the gamma calibration. After calibrating the gamma, there's a brightness/contrast step and a color calibration step, you may skip these.</p>\r
            <p>If you don't want to change your display settings permanently, all you need to do is (1) select "current calibration", (2) run the experiment, and (3) cancel the calibration.</p>\r
            <div style="text-align: center;">\r
                <img src="./img/calibrate.png">\r
            </div>\r
        </article>\r
    <!-- </div> -->\r
</div>\r
<div id="navigation">\r
  <button id="next-task">Next</button>\r
</div>`,R=`<div id="tasks" class="choice">\r
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
</div>`,F=`<div id="tasks">\r
    <!-- <div class="info"> -->\r
        <article>\r
            <h1>Experiment results</h1>\r
            <p>Copy the text below to share the results of the experiment.</p>\r
            <textarea id="results" readonly value="Loading results..."></textarea>\r
        </article>\r
    <!-- </div> -->\r
</div>`,_=`{\r
    "trials": 40,\r
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
}`;var u=(t=>(t[t.Left=0]="Left",t[t.Right=1]="Right",t))(u||{});class S{toString(){return"IntroTask()"}}class L{toString(){return"CalibrateTask()"}}class v{constructor(e){o(this,"id");this.id=e}toString(){return"ShowTask("+this.id+")"}}class k{constructor(e,n,i){o(this,"id");o(this,"left");o(this,"right");o(this,"choice");this.id=e,this.left=n,this.right=i,this.choice=null}choose(e){this.choice=e}toString(){return"ChoiceTask("+this.id+"/"+this.left+" or "+this.id+"/"+this.right+")"}}class m{constructor(e){o(this,"started",!1);o(this,"remaining",3e3);this.remaining=e}start(){this.started=!0;let e=this,n=setInterval(()=>{document.hasFocus()&&(e.remaining-=250)},250);setTimeout(()=>{clearInterval(n)},this.remaining+500)}clear(){this.remaining=0,this.started=!0}get isReady(){return this.remaining<=0}toString(){return"WaitTask("+(this.started?"[counting] ":"[paused] ")+String(this.remaining)+"ms)"}}class N{toString(){return"GoodbyeTask()"}}class O{constructor(e){o(this,"taskIndex",0);o(this,"tasks");o(this,"earlyTermination",!1);const n=e.trials||0,i=(e.algorithms||[]).filter(l=>l.enabled),s=e.images||[];this.tasks=[],this.tasks.push(new S),this.tasks.push(new L);let a=z(i),c=x(a),b=x(s);for(const l of Array(n).keys()){const g=b.next().value,w=c.next().value;this.tasks.push(new v(g)),this.tasks.push(new k(g,w[0].id,w[1].id)),l<n-1&&this.tasks.push(new m(e.wait_ms))}this.tasks.push(new N),this.logNextTask()}get currentTask(){return this.tasks[this.taskIndex]}get hasNext(){return this.taskIndex<this.tasks.length-1}get canAdvance(){return this.currentTask instanceof m?(console.log(this.currentTask.remaining),console.log(this.currentTask.started),this.hasNext&&this.currentTask.isReady):this.currentTask instanceof k?this.hasNext&&this.currentTask.choice!=null:this.hasNext}nextTask(){return this.canAdvance?(this.taskIndex+=1,this.logNextTask(),this.currentTask instanceof m&&this.currentTask.start(),!0):!1}terminate(){this.taskIndex=this.tasks.length-1,this.earlyTermination=!0}logNextTask(){console.log("Starting task "+String(this.taskIndex)+"/"+this.tasks.length+": "+this.currentTask.toString())}}function T(t){let e=[...Array(t).keys()],n=t;for(;n!=0;){let i=Math.floor(Math.random()*n);n--,[e[n],e[i]]=[e[i],e[n]]}return e}function z(t){return t.flatMap(e=>t.map(n=>[e,n]))}function*x(t){let e=T(t.length),n=0;for(;;)yield t[e[n]],n++,n==t.length&&(n=0,e=T(t.length))}function p(t){if(t==null){console.error("'task' is null");return}t instanceof S&&K(),t instanceof L&&P(),t instanceof v&&B(t),t instanceof k&&G(t),t instanceof m&&Y(t),t instanceof N&&J(),I()}function K(t){h().innerHTML=E,d(f())}function P(t){h().innerHTML=C,d(f())}function B(t){h().innerHTML=R,D(t),d(f())}function G(t){h().innerHTML=W,U(t),d(f())}function Y(t){h().innerHTML=A,Z(t),d(f())}function J(t){h().innerHTML=F,X(),d(f()),console.log(r)}function D(t){let e=document.querySelector("#show-img");if(e==null){console.error("'img' is null");return}e.src="./img/"+t.id+"/base.png"}function U(t){let e=document.querySelector("#left-img"),n=document.querySelector("#right-img");if(e==null){console.error("'left' is null");return}if(n==null){console.error("'right' is null");return}e.addEventListener("click",i=>{y(u.Left)}),n.addEventListener("click",i=>{y(u.Right)}),e.src="./img/"+t.id+"/"+t.left+".png",n.src="./img/"+t.id+"/"+t.right+".png"}function y(t){if(!((r==null?void 0:r.currentTask)instanceof k))return;let e=document.querySelector("#left-container"),n=document.querySelector("#right-container");e.classList.remove("unmarked-choice","other-choice","selected-choice"),n.classList.remove("unmarked-choice","other-choice","selected-choice"),t===null&&(e.classList.add("unmarked-choice"),n.classList.add("unmarked-choice")),t===u.Left&&(e.classList.add("selected-choice"),n.classList.add("other-choice")),t===u.Right&&(e.classList.add("other-choice"),n.classList.add("selected-choice")),r.currentTask.choose(t)}function Z(t){const e=document.querySelector("#countdown");if(e==null){console.error("'countdown' is null");return}let n=!0;const i=setInterval(()=>{document.hasFocus()&&(t.remaining>0?e.innerText="Please wait "+String(Math.ceil(t.remaining/1e3))+" seconds...":(n&&(n=!1,r.nextTask(),p(r.currentTask)),e.innerText="You may continue now."))},50);setTimeout(()=>{clearInterval(i)},t.remaining+500)}function X(t){const e=document.querySelector("#results");if(e==null){console.error("'results' is null");return}e.value=JSON.stringify(r.tasks.filter(n=>n instanceof k))}function j(t){M()}function M(){if(r==null){console.error("'experiment' is null");return}r.nextTask()&&p(r.currentTask)}function Q(){if(r==null){console.error("'experiment' is null");return}r.terminate(),p(r.currentTask)}function V(t){if(t==null){console.error("'element' is null");return}let e=r==null?void 0:r.tasks.slice(0,(r==null?void 0:r.taskIndex)+1).filter(i=>i instanceof v).length,n=r==null?void 0:r.tasks.filter(i=>i instanceof v).length;t.innerHTML="Next ("+String(e)+"/"+String(n)+")",t.addEventListener("click",j)}function d(t){if(t==null){console.error("'element' is null");return}V(t.querySelector("#next-task"))}function $(t){t==="KeyS"&&M(),t==="KeyA"&&y(u.Left),t==="KeyD"&&y(u.Right),t==="KeyW"&&y(null),t==="Escape"&&Q()}function I(){const t=document.querySelector("#navigation"),n=document.querySelector("#tasks").getElementsByTagName("img"),i=window.innerWidth,s=window.innerHeight-t.offsetHeight+100,a=Math.min(i,s),c=Math.max(i,s),l=Math.min(a,c/2.2)/1e3;for(const g of n)l<1?g.style.maxWidth=String(1e3/Math.pow(2,Math.ceil(Math.log2(1/l))))+"px":g.style.maxWidth=String(1e3*Math.floor(l)/2)+"px";console.log("Resized = ["+i+", "+s+"], Factor = "+l)}function tt(t){$(t.code)}function et(t){I()}function nt(t){(r==null?void 0:r.currentTask)instanceof m&&(r==null||r.currentTask.clear(),p(r.currentTask))}let h=()=>document.querySelector("#experiment"),f=()=>document.querySelector("#navigation"),r=new O(JSON.parse(_));document.addEventListener("keyup",tt);window.addEventListener("resize",et);window.addEventListener("focus",nt);p((r==null?void 0:r.currentTask)||null);
