document.addEventListener('DOMContentLoaded', function() {
    let chooseTemplateBtn = document.getElementById('chooseTemplateBtn');
    let carousel = document.getElementById('templateCarousel');
    chooseTemplateBtn.href = "<%= url_for(controller: 'storefronts', action: 'choose_template') %>?template_number=1";

    carousel.addEventListener('slide.bs.carousel', function (event) {
        let activeIndex = event.to + 1;
        chooseTemplateBtn.removeAttribute('href');
        chooseTemplateBtn.href = "<%= url_for(controller: 'storefronts', action: 'choose_template') %>?template_number=" + activeIndex;
    });
});
