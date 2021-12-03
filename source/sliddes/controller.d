/// Remote control API.
module sliddes.controller;

import lighttp;

import std.conv;
import std.concurrency;

import sliddes.transmitter;

class Controller {

    Tid target;

    this(Tid target) {

        this.target = target;

    }

    void prepareResponse(ServerResponse response) {

        response.contentType = "text/plain";
        response.headers["Access-Control-Allow-Origin"] = "*";

    }

    @Get("sliddes/next-slide")
    void nextSlide(ServerResponse response) {

        prepareResponse(response);
        response.body = "OK";

        target.send(OffsetSlideMsg(1));

    }

    @Get("sliddes/previous-slide")
    void previousSlide(ServerResponse response) {

        prepareResponse(response);
        response.body = "OK";

        target.send(OffsetSlideMsg(-1));

    }

    @Get("sliddes/slide", r"(\d+)")
    void setSlide(ServerResponse response, string slide) {

        prepareResponse(response);

        response.body = "OK " ~ slide;
        target.send(SetSlideMsg(slide.to!size_t));

    }

    @Get("sliddes/test", r"(\d+)")
    void test(ServerResponse response, string id) {

        prepareResponse(response);

        response.body = "OK " ~ id;
        target.send(TestMsg(id.to!int));

    }

}
