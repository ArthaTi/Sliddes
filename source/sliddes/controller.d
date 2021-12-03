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

    @Get("sliddes/next-slide")
    void nextSlide(ServerResponse response) {

        response.contentType = "text/plain";
        response.body = "OK";

        target.send(OffsetSlideMsg(1));

    }

    @Get("sliddes/previous-slide")
    void previousSlide(ServerResponse response) {

        response.contentType = "text/plain";
        response.body = "OK";

        target.send(OffsetSlideMsg(-1));

    }

    @Get("sliddes/slide", r"(\d+)")
    void setSlide(ServerResponse response, string slide) {

        response.contentType = "text/plain";

        try {

            const slideID = slide.to!size_t;
            response.body = "OK " ~ slide;
            target.send(SetSlideMsg(slideID));

        }

        // This shouldn't ever happen for this regex, unless there's a deliberate attack
        catch (ConvException) {

            assert(false, "Couldn't convert to size_t");

        }

    }

}
