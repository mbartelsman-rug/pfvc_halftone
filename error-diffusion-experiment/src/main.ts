let image_ids = [
    "image-1",
    "image-2",
    "image-3",
    "image-4",
]

function nextTask() {
    console.log("Next task");
    for (const id of image_ids) {
        let image = document.getElementById(id) as HTMLImageElement;
        image.src = "https://placehold.co/600x600?text=" + String(Math.trunc(Math.random() * 1000));
    }
    resetVotes();
}

function prevTask() {
    console.log("Next task");
    let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (const id of image_ids) {
        let image = document.getElementById(id) as HTMLImageElement;
        image.src = "https://placehold.co/600x600?text=" + letters[Math.trunc(Math.random() * letters.length)];
    }  
}

function resetVotes() {
    for (const imageId of [1, 2, 3, 4]) {
        for (const rankId of [1, 2, 3, 4]) {
            let button = document.getElementById("vote-" + String(imageId) + String(rankId)) as HTMLButtonElement;
            button.style.backgroundColor = "blue";
        }
    }
}

function vote(image, rank) {
    for (const imageId of [1, 2, 3, 4]) {
        let button = document.getElementById("vote-" + String(imageId) + String(rank)) as HTMLButtonElement;
        button.style.backgroundColor = imageId == image ? "green" : "black";
    }
    for (const rankId of [1, 2, 3, 4]) {
        let button = document.getElementById("vote-" + String(image) + String(rankId)) as HTMLButtonElement;
        button.style.backgroundColor = rankId == rank ? "green" : "black";
    }
}