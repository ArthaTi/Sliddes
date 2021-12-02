module sliddes.presentation;

import elemi;

import std.algorithm;
import std.exception;


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

        return this;

    }

    /// Render and write out the presentation.
    void generate(string output = "public") const {

        import std.file, std.path;

        // Create the output directory
        output.mkdirRecurse();

        // Load stylesheet
        copy(
            buildPath(thisExePath.dirName, "resources/basic.css"),
            buildPath(output, "basic.css"),
        );

        // Generate the presentation
        buildPath(output, "index.html")
            .write(render);

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
            ),
            elem!"body"(
                elem!"noscript"(
                    "Warning! JavaScript is disabled. This page won't work without it."
                ),
                slides,
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
