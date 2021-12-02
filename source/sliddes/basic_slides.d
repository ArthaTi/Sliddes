module sliddes.basic_slides;

import elemi;

import sliddes.presentation;


@safe:


Element titleSlide(ref Presentation pres, string subtitle = null) {

    // Create the title
    auto content = elems(
        elem!"h1"(pres.title.elem!"span")
    );

    // Add subtitle
    if (subtitle.length) content ~= elem!"h2"(subtitle.elem!"span");

    return pres.boilerplate("title-slide")
        .add!"div"(content);

}

Element sectionSlide(ref Presentation pres, string title) {

    return pres.boilerplate("section-slide")
        .add!"div"(
            elem!"h2"(title.elem!"span"),
        );

}

Element textSlide(ref Presentation pres, string[] text...) {

    import std.algorithm;

    return pres.boilerplate("text-slide")
        .add!"div"(
            text.map!(a => elem!"p"(a.elem!"span")),
        );

}

Element imageSlide(ref Presentation pres, string image, string caption = null) {

    return pres.boilerplate("image-slide")
        .add!"div"(
            elem!"img"(
                attr("src") = image,
                attr("alt") = "",  // no alt as the caption is publictly visible
            ),
            elem!"p"(caption.elem!"span"),
        );

}
