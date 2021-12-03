module sliddes.presentation;

import elemi;

import std.string;
import std.algorithm;
import std.exception;

import sliddes.controller;
import sliddes.transmitter;


@safe:


struct Presentation {

    public {

        string title;
        string stylesheet;

        /// Template for each slide
        Element delegate(string[] cls...) boilerplate;

    }

    private {

        Element slides;
        string[] slideTitles;
        Element[] slideNotes;

    }

    ref Presentation add(alias fun, T...)(T args) {

        import std.traits;

        alias Params = Parameters!fun;

        // Prepare the template
        if (!boilerplate) {

            boilerplate = delegate(string[] cls...)
                => elem!"div"(
                    attr("class") = ["slide"] ~ cls,
                );

        }

        slides ~= fun(this, args);

        // Get the args for the admin panel
        string titleFun = __traits(identifier, fun);
        string titleArgs;

        foreach (i, arg; args) {

            if (i+1 == args.length) {
                titleArgs ~= format!"%s"(arg);
            }
            else titleArgs ~= format!"%s, "(arg);

        }

        slideTitles ~= format!"%s(%s)"(titleFun, titleArgs);

        return this;

    }

    /// Add a note for the last added presentation slide.
    ref Presentation addNote(T...)(T notes) return {

        slideNotes.length = slideTitles.length;
        slideNotes[$-1] = elems(notes);

        return this;

    }

    /// Render and write out the presentation.
    ref inout(Presentation) generate(string output = "public") inout {

        import std.file, std.path;

        // Create the output directory
        output.mkdirRecurse();

        void copyResource(string name) {

            copy(
                buildPath(thisExePath.dirName, "resources", name),
                buildPath(output, name),
            );

        }

        // Load stylesheet
        copyResource("basic.css");
        copyResource("receiver.js");

        // Load scripts
        copy(
            buildPath(thisExePath.dirName, "resources/basic.css"),
            buildPath(output, "basic.css"),
        );

        // Generate the presentation
        buildPath(output, "index.html")
            .write(render);

        // Generate the admin panel
        buildPath(output, "admin.html")
            .write(renderAdmin);

        return this;

    }

    /// Start the presentation server.
    noreturn present() const @trusted {

        import lighttp;
        import std.concurrency;

        // Spawn transmitter thread
        auto tid = spawn({

            with (new Server) {

                host("127.0.0.1", 8091);
                router.add(new Transmitter);
                run();

            }

        });

        // Run controller
        with (new Server) {

            host("127.0.0.1", 8090);
            router.add(new Controller(tid));
            run();

        }

    }

    /// Render the presentation.
    string render() const {

        enforce(slides.length != 0, "No slides present.");

        // Add basic stylesheet
        auto stylesheets = elems(
            elem!"link"(
                attr("rel") = "stylesheet",
                attr("href") = "basic.css",
            ),
        );

        // Add custom stylesheet
        if (stylesheet.length) {

            stylesheets ~= elem!"link"(
                attr("rel") = "stylesheet",
                attr("href") = stylesheet,
            );

        }

        // Generate the presentation
        return Element.HTMLDoctype ~ elem!"html"(

            elem!"head"(
                Element.MobileViewport,
                Element.EncodingUTF8,

                stylesheets,

                elem!"title"(title),
                elem!"script"(
                    attr("src") = "receiver.js"
                ),
            ),
            elem!"body"(
                elem!"noscript"(
                    "Warning! JavaScript is disabled. This page won't work without it."
                ),
                slides,
            ),

        );

    }

    string renderAdmin() const {

        import std.range;

        // Ensure there are at least some empty notes for the last slides
        const(Element)[] notes = slideNotes;
        notes.length = slideTitles.length;

        return Element.HTMLDoctype ~ elem!"html"(

            elem!"head"(
                Element.MobileViewport,
                Element.EncodingUTF8,

                elem!"title"(title ~ " — admin"),
            ),

            elem!"body"(

                elem!"ol"(
                    attr("class") = ["slide-list"],

                    iota(slideTitles.length).map!(i =>
                        elem!"li"(
                            elem!"a"(
                                attr("href") = format!"#slide%s"(i),
                                slideTitles[i]
                            )
                        )
                    )

                ),

                iota(slideTitles.length).map!(i =>

                    elem!"div"(
                        attr("id") = format!"slide%s"(i),
                        elem!"h2"(slideTitles[i]),
                        notes[i],
                    ),

                ),

            ),

        );

    }

}

unittest {

    import sliddes.basic_slides;

    Presentation("Welcome to my presentation")
        .add!titleSlide("This is a subtitle")
        .generate("public/test1");

}
