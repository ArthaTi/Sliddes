document.addEventListener("DOMContentLoaded", listen);

let currentSlide = 0;

async function listen() {

    console.log("listening...");

    try {

        // Receive data from the server
        let result = await fetch("/sliddes");
        let data   = await result.json();

        console.log("received");

        // Proces the data and listen again
        await process(data);
        listen();

    }

    catch (exc) {

        // Log any potential errors, try again
        console.error(exc);
        setTimeout(listen, 1500);

    }

}

async function process(data) {

    console.log("result:", data);

    // Slide management

    if ("slide" in data) {

        setSlide(data["slide"]);

    }

    else if ("offset" in data) {

        setSlide(currentSlide + data["offset"]);

    }

    else if ("test" in data) {

        popup("Test message from: " + data["test"]);

    }

}

function setSlide(target) {

    assert(typeof target === "number", "target must be a number");

    try {

        document.querySelectorAll(".slide")[target].scrollIntoView();
        currentSlide = target;

    }

    // But we don't care. Just don't set the slide.
    catch (exc) { }

}

function assert(cond, msg) {

    if (!cond) throw new Exception(msg);

}

function popup(message) {

    let target = document.getElementById("popup-area");
    let content = document.createTextNode(message);

    let thing = document.createElement("div");
    thing.classList.add("popup");
    thing.appendChild(content);

    let outerThing = document.createElement("div");
    outerThing.appendChild(thing);

    target.appendChild(outerThing);

    setTimeout(() => target.removeChild(outerThing), 5000);

}
