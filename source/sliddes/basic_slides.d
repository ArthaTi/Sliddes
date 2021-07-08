module sliddes.basic_slides;

import elemi;

import sliddes.slide;


@safe:


class TitleSlide : Slide {

    string title;
    string subtitle;

    this(string title, string subtitle = null) {

        this.title = title;
        this.subtitle = subtitle;

        classes ~= "slide-title";

    }

    override Element content() const pure{

        auto ret = elems(
            elem!"h1"(title),
        );

        // If there's a subtitle, add it
        if (subtitle.length) ret ~= elem!"h2"(subtitle);

        return ret;

    }

}
