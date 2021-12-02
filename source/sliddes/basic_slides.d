module sliddes.basic_slides;

import elemi;

import sliddes.presentation;


@safe:


Element titleSlide(ref Presentation pres, string subtitle = null) {

    return pres.boilerplate("title-slide")
        .add!"div"(
            elem!"h1"(pres.title),
            elem!"h2"(subtitle),
        );

}
