module sliddes.basic_slides;

import elemi;

import sliddes.presentation;


@safe:


Element titleSlide(ref Presentation pres, string subtitle = null) {

    // Create the title
    auto content = elems(
        elem!"h1"(pres.title)
    );

    // Add subtitle
    if (subtitle.length) content ~= elem!"h2"(subtitle);

    return pres.boilerplate("title-slide")
        .add!"div"(content);

}

Element sectionSlide(ref Presentation pres, string title) {

    return pres.boilerplate("section-slide")
        .add!"div"(
            elem!"h2"(title),
        );

}

Element textSlide(ref Presentation pres, string[] text...) {

    import std.algorithm;

    return pres.boilerplate("text-slide")
        .add!"div"(
            text.map!(a => elem!"p"(a)),
        );

}

Element imageSlide(ref Presentation pres, string image, string caption = null) {

    return pres.boilerplate("image-slide")
        .add!"div"(
            elem!"img"(
                attr("src") = image,
                attr("alt") = "",  // no alt as the caption is publictly visible
            ),
            elem!"p"(caption),
        );

}
