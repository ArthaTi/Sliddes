module sliddes.slide;

import elemi;

import sliddes.presentation;


@safe:


/// Slide creation tool.
struct Slide {

    public {

        string title = "";
        string slideType = "";
        string background;
        Element topLeft;
        Element topRight;
        Element bottomLeft;
        Element bottomRight;

    }

    ref Slide adjust(void delegate(ref Slide) @safe modifier) return {

        modifier(this);
        return this;

    }

    Element output(ref Presentation pres) {

        import std.string;

        auto html = pres.boilerplate(slideType);
        auto content = elem!"div";

        Element side(Element left, Element right) {

            auto parent = elems;

            if (left) parent.add!"div"(
                attr("class") = ["left"],
                left
            );
            if (right) parent.add!"div"(
                attr("class") = ["right"],
                right
            );

            return parent;

        }

        // Add background
        html.add = attr("style", format!"background-image: url(%s)"(background));

        // Add top text
        if (topLeft || topRight) {

            content.add(
                elem!"div"(
                    attr("class") = ["top"],
                    side(topLeft, topRight)
                )
            );

        }

        // Add bottom text
        if (bottomLeft || bottomRight) {

            content.add(
                elem!"div"(
                    attr("class") = ["bottom"],
                    side(bottomLeft, bottomRight),
                )
            );

        }

        return html.add(content);

    }

    string toString() const {

        return title;

    }

}
