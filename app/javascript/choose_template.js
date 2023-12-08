document.addEventListener('turbo:load', function() {
    let storefront_custom_code = document.getElementById('storefront_custom_code');
    let carousel = document.getElementById('templateCarousel');

    carousel.addEventListener('slide.bs.carousel', function (event) {
        storefront_custom_code.value = event.to + 1;
    });
});
