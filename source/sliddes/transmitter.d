/// Listener which runs on a separate thread the presentation listens to to receive messages.
module sliddes.transmitter;

import lighttp;

import std.stdio;
import std.format;
import std.concurrency;

class Transmitter {

    @Get("sliddes")
    void listener(ServerResponse response) {

        response.contentType = "application/json";

        receive(
            (SetSlideMsg msg) {
                writeln(msg);
                response.body = format!q{ {"slide": %s} }(msg.slide);
            },
            (OffsetSlideMsg msg) {
                writeln(msg);
                response.body = format!q{ {"offset": %s} }(msg.offset);
            }
        );

    }

}

struct SetSlideMsg {

    size_t slide;

}

struct OffsetSlideMsg {

    ptrdiff_t offset;

}
