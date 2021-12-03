document.addEventListener("DOMContentLoaded", setID);

function setID() {

    const min = 1;
    const max = 10000;

    let target = document.getElementById("test-id");
    target.value = Math.floor(Math.random() * (max - min) + min)

}

function url(post) {

    let loc = new URL(location);
    loc.port = "8090";
    loc.pathname = "/sliddes" + post;

    return loc;

}

function switchTo(slide) {

    fetch(url("/slide/" + slide), { mode: "cors" });

}

function test() {

    let id = document.getElementById("test-id").value;

    fetch(url("/test/" + id), { mode: "cors" });

}
