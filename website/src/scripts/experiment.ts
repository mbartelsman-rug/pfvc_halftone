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
        
        let pairs = getPairs(algorithms);
        let pairChoice = getRandom(pairs);
        let imageChoice = getRandom(images);

        for (const i of Array(trials).keys()) {
            const img = imageChoice.next().value;
            const pair = pairChoice.next().value;
            this.tasks.push(new ShowTask(img));
            this.tasks.push(new ChoiceTask(img, pair[0].id, pair[1].id));

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

function shuffle(count: number): number[] {
    let indices = [...Array(count).keys()];
    let currentIndex = count;
  
    // While there remain elements to shuffle...
    while (currentIndex != 0) {
        // Pick a remaining element...
        let randomIndex = Math.floor(Math.random() * currentIndex);
        currentIndex--;

        // And swap it with the current element.
        [indices[currentIndex], indices[randomIndex]] = [indices[randomIndex], indices[currentIndex]];
    }
    return indices;
}

function getPairs<T>(list: T[]): [T, T][] {
    return list.flatMap(e1 => list.map(e2 => [e1, e2]) as [T, T][]);
}

function* getRandom<T>(list: T[]): Generator<T> {
    let bag = shuffle(list.length);
    let i = 0;
    while (true) {
        yield list[bag[i]];
        i++;

        if (i == list.length) {
            i = 0;
            bag = shuffle(list.length);
        }
    }
}