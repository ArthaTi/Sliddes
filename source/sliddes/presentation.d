module sliddes.presentation;

import elemi;

import std.algorithm;
import std.exception;

import sliddes.slide;


@safe:


struct Presentation {

    string stylesheet;
    Slide[] slides;

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
        buildPath(output, "presentation.html")
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

            ),
            elem!"body"(
                elem!"noscript"(
                    "Warning! JavaScript is disabled. This page won't work without it."
                ),
                slides.map!"a.render",
            ),

        );

    }

}

unittest {

    import sliddes.basic_slides;

    Presentation pres;
    pres.slides ~= new TitleSlide("Welcome to my presentation", "More info...");

    pres.generate("public/test1");

}
