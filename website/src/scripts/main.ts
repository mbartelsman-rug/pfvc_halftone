// import './styles/style.css'
import introHtml from "../data/intro_task.html?raw";
import calibrateHtml from "../data/calibrate_task.html?raw";
import showHtml from "../data/show_task.html?raw";
import choiceHtml from "../data/choice_task.html?raw";
import waitHtml from "../data/wait_task.html?raw";
import goodbyeHtml from "../data/goodbye_task.html?raw";

import { AnyTask, CalibrateTask, Choice, ChoiceTask, Configuration, Experiment, GoodbyeTask, IntroTask, ShowTask, WaitTask } from "./experiment";

function loadTask(task: AnyTask | null): void {
    if (task == null) {
        console.error("'task' is null");
        return;
    }

    if (task instanceof IntroTask) loadIntro(task);
    if (task instanceof CalibrateTask) loadCalibrate(task);
    if (task instanceof ShowTask) loadShow(task);
    if (task instanceof ChoiceTask) loadChoice(task);
    if (task instanceof WaitTask) loadWait(task);
    if (task instanceof GoodbyeTask) loadGoodbye(task);
    
    imageResize();
}

function loadIntro(_: IntroTask): void {
    experimentHtml()!.innerHTML = introHtml;
    setupNavigation(navigationHtml());
}

function loadCalibrate(_: CalibrateTask): void {
    experimentHtml()!.innerHTML = calibrateHtml;
    setupNavigation(navigationHtml());
}

function loadShow(task: ShowTask): void {
    experimentHtml()!.innerHTML = showHtml;
    setupShow(task);
    setupNavigation(navigationHtml());
}

function loadChoice(task: ChoiceTask): void {
    experimentHtml()!.innerHTML = choiceHtml;
    setupChoice(task);
    setupNavigation(navigationHtml());
}

function loadWait(task: WaitTask): void {
    experimentHtml()!.innerHTML = waitHtml;
    setupWait(task);
    setupNavigation(navigationHtml());
}

function loadGoodbye(task: GoodbyeTask): void {
    experimentHtml()!.innerHTML = goodbyeHtml;
    setupGoodbye(task);
    setupNavigation(navigationHtml());
    console.log(experiment!);
}

function setupShow(task: ShowTask): void {
    let img = document.querySelector<HTMLImageElement>("#show-img")

    if (img == null) {
        console.error("'img' is null");
        return;
    }

    img.src = "./public/img/" + task.id + "/base.png";
}

function setupChoice(task: ChoiceTask): void {
    let left = document.querySelector<HTMLImageElement>("#left-img")
    let right = document.querySelector<HTMLImageElement>("#right-img")
    
    if (left == null) {
        console.error("'left' is null");
        return;
    }
    
    if (right == null) {
        console.error("'right' is null");
        return;
    }

    left.addEventListener("click", (_) => { choose(Choice.Left) });
    right.addEventListener("click", (_) => { choose(Choice.Right) });

    left.src = "./public/img/" + task.id + "/" + task.left + ".png";
    right.src = "./public/img/" + task.id + "/" + task.right + ".png";
}

function choose(choice: Choice | null): void {
    if (!(experiment?.currentTask instanceof ChoiceTask)) {
        return;
    }

    let left = document.querySelector<HTMLDivElement>("#left-container")!;
    let right = document.querySelector<HTMLDivElement>("#right-container")!;
    
    left.classList.remove("unmarked-choice", "other-choice", "selected-choice");
    right.classList.remove("unmarked-choice", "other-choice", "selected-choice");
    
    if (choice === null) {
        left.classList.add("unmarked-choice");
        right.classList.add("unmarked-choice");
    }
    if (choice === Choice.Left) {
        left.classList.add("selected-choice");
        right.classList.add("other-choice");
    }
    if (choice === Choice.Right) {
        left.classList.add("other-choice");
        right.classList.add("selected-choice");
    }
    
    experiment.currentTask.choose(choice)
}

function setupWait(task: WaitTask): void {
    const counter = document.querySelector<HTMLSpanElement>("#countdown");
    
    if (counter == null) {
        console.error("'countdown' is null");
        return;
    }

    let once = true;
    const interval = setInterval(() => {
        if ( document.hasFocus() ) {
            if (task.remaining > 0) {
                counter.innerText = "Please wait " + String(Math.round(task.remaining / 100) / 10) + " seconds..."
            }
            else {
                if (once) {
                    once = false;
                    experiment!.nextTask();
                    loadTask(experiment!.currentTask);
                }
                counter.innerText = "You may continue now."
            }
        }
    }, 50);

    setTimeout(() => {
            clearInterval(interval);
        }, task.remaining + 500);

}

function setupGoodbye(_: GoodbyeTask): void {
    const results = document.querySelector<HTMLInputElement>("#results");
    
    if (results == null) {
        console.error("'results' is null");
        return;
    }

    results.value = JSON.stringify(experiment);
}

function onClickNextTask(this: HTMLButtonElement, _: MouseEvent): void {
    nextTask();
}

function nextTask(): void {
    if (experiment == null) {
        console.error("'experiment' is null");
        return;
    }
    if (experiment.nextTask()) {
        loadTask(experiment.currentTask);
    }
}

function terminate(): void {
    if (experiment == null) {
        console.error("'experiment' is null");
        return;
    }
    experiment.terminate();
    loadTask(experiment.currentTask);
}

function setUpNextButton(element: HTMLButtonElement | null) {
    if (element == null) {
        console.error("'element' is null");
        return;
    }
    let current = experiment?.tasks.slice(0, experiment?.taskIndex! + 1).filter(task => task instanceof ShowTask).length;
    let total = experiment?.tasks.filter(task => task instanceof ShowTask).length;
    element.innerHTML = "Next (" + String(current) + "/" + String(total) + ")"

    element.addEventListener("click", onClickNextTask)
}

function setupNavigation(element: HTMLDivElement | null) {
    if (element == null) {
        console.error("'element' is null");
        return;
    }

    setUpNextButton(element.querySelector("#next-task"));
}

function keyNavigation(keycode: string): void {
    if (keycode === "KeyS") { nextTask() }
    if (keycode === "KeyA") { choose(Choice.Left) }
    if (keycode === "KeyD") { choose(Choice.Right) }
    if (keycode === "KeyW") { choose(null) }
    if (keycode === "Escape") { terminate() }
}

function imageResize(): void {
    const nav = document.querySelector<HTMLDivElement>("#navigation")!;
    const tasks = document.querySelector<HTMLDivElement>("#tasks")!;
    const imgs = tasks.getElementsByTagName("img");
    const viewWidth = window.innerWidth;
    const viewHeight = window.innerHeight - nav.offsetHeight + 100;

    const smallest = Math.min(viewWidth, viewHeight);
    const largest = Math.max(viewWidth, viewHeight);
    const relevant = Math.min(smallest, largest / 2.2);

    const factor = relevant / 1000;

    for (const img of imgs) {
        if (factor < 1) {
            img.style.maxWidth = String(1000 / Math.pow(2, Math.ceil(Math.log2(1 / factor)))) + "px";
        }
        else {
            img.style.maxWidth = String(1000 * Math.floor(factor) / 2) + "px";
        }
    }
    console.log("Resized = [" + viewWidth + ", " + viewHeight + "], Factor = " + factor);
    
}

function onKeyUp(event: KeyboardEvent): void {
    keyNavigation(event.code);
}


function onResize(event: UIEvent): void {
    imageResize();
}


function onFocus(event: FocusEvent): void {
    if (experiment?.currentTask instanceof WaitTask) {
        experiment?.currentTask.clear()
        loadTask(experiment.currentTask);
    }
}


let experiment = await fetch("src/data/configuration.json")
    .then(response => response.json())
    .then(data => data as Configuration)
    .then(conf => new Experiment(conf))
    .catch(_ => { console.error("Could not fetch configuration"); return null; });

let experimentHtml = () => document.querySelector<HTMLDivElement>("#experiment");
let navigationHtml = () => document.querySelector<HTMLDivElement>("#navigation");

document.addEventListener("keyup", onKeyUp);
window.addEventListener("resize", onResize);
window.addEventListener("focus", onFocus);

loadTask(experiment?.currentTask || null);
