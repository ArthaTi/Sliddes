module sliddes.slide;

import elemi;


@safe:


abstract class Slide {

    string[] classes;

    abstract Element content() const pure;

    final Element render() const pure {

        return elem!"div"(
            attr("class") = ["slide"] ~ classes,
            content,
        );

    }

}
