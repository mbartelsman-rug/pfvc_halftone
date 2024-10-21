// import '../data/configuration.json'

export enum Choice {
    Left,
    Right,
};

export class IntroTask {
    toString(): string {
        return "IntroTask()";
    }
};

export class CalibrateTask {
    toString(): string {
        return "CalibrateTask()";
    }
};

export class ShowTask {
    id: string;

    constructor(id: string) {
        this.id = id;
    }

    toString(): string {
        return "ShowTask(" + this.id + ")";
    }
};

export class ChoiceTask {
    id: string;
    left: string;
    right: string;
    choice: Choice | null;

    constructor(id: string, left: string, right: string) {
        this.id = id;
        this.left = left;
        this.right = right;
        this.choice = null;
    }

    choose(choice: Choice | null) {
        this.choice = choice;
    }

    toString(): string {
        return "ChoiceTask(" + this.id + "/" + this.left + " or " + this.id + "/" + this.right + ")";
    }
};

export class WaitTask {
    started: boolean = false;
    remaining: number = 3000;

    constructor(wait: number) {
        this.remaining = wait;
    }
    
    start() {
        this.started = true;
        let thisTask = this;

        let interval = setInterval(() => {
            if ( document.hasFocus() ) {
                thisTask.remaining -= 250;
            }
        }, 250);

        setTimeout(() => {
            clearInterval(interval)
        }, this.remaining + 500);
    }

    clear() {
        this.remaining = 0;
        this.started = true;
    }

    get isReady(): boolean {
        return this.remaining <= 0;
    }

    toString(): string {
        return "WaitTask(" + (this.started ? "[counting] " : "[paused] ") + String(this.remaining) + "ms)";
    }
};

export class GoodbyeTask {
    toString(): string {
        return "GoodbyeTask()";
    }
};

export type AnyTask = IntroTask | ShowTask | ChoiceTask | WaitTask;

export class Experiment {
    taskIndex: number = 0;
    tasks: AnyTask[];
    earlyTermination: boolean = false;

    constructor(configuration: Configuration) {
        const trials = configuration.trials || 0;
        const algorithms = (configuration.algorithms || []).filter((value) => value.enabled);
        const images = configuration.images || [];

        this.tasks = [];
        this.tasks.push(new IntroTask());
        this.tasks.push(new CalibrateTask());
        for (const i of Array(trials).keys()) {
            const image = getNFrom(1, images)[0];
            const [left, right] = getNFrom(2, algorithms);
            
            this.tasks.push(new ShowTask(image));
            this.tasks.push(new ChoiceTask(image, left.id, right.id));

            if (i < trials - 1)
                this.tasks.push(new WaitTask(configuration.wait_ms));
        }
        this.tasks.push(new GoodbyeTask());
        this.logNextTask();
    }

    get currentTask(): AnyTask {
        return this.tasks[this.taskIndex];
    }
    
    get hasNext(): boolean {
        return this.taskIndex < this.tasks.length - 1;
    }
    
    get canAdvance(): boolean {
        if (this.currentTask instanceof WaitTask) {
            console.log(this.currentTask.remaining);
            console.log(this.currentTask.started);
            
            return this.hasNext && this.currentTask.isReady;
        }
        if (this.currentTask instanceof ChoiceTask) {
            return this.hasNext && this.currentTask.choice != null;
        }

        return this.hasNext;
    }

    nextTask(): boolean {
        if (!this.canAdvance) return false;

        this.taskIndex += 1;
        this.logNextTask();
        if (this.currentTask instanceof WaitTask)
            this.currentTask.start();

        return true;
    }

    terminate() {
        this.taskIndex = this.tasks.length - 1;
        this.earlyTermination = true;
    }

    logNextTask() {
        console.log("Starting task " + String(this.taskIndex) + "/" + this.tasks.length + ": " + this.currentTask.toString());
    }
};

export interface AlgoInfo {
    id: string,
    name: string,
    enabled: boolean
};

export interface Configuration {
    trials: number | null,
    algorithms: AlgoInfo[] | null,
    images: string[] | null,
    wait_ms: number,
};

function getNFrom<T>(count: number, array: T[]): T[] {
    let indices = [...Array(array.length).keys()];
    let currentIndex = indices.length;
  
    // While there remain elements to shuffle...
    while (currentIndex != 0) {
        // Pick a remaining element...
        let randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex--;

        // And swap it with the current element.
        [indices[currentIndex], indices[randomIndex]] = [indices[randomIndex], indices[currentIndex]];
    }
    let result = indices.slice(0, count).map((value) => array[value]);
    return result;
}