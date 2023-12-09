document.addEventListener("DOMContentLoaded", function() {
    console.log('DOM loaded with JavaScript')
    const carouselItems = document.querySelectorAll('.carousel-item');
    const categories = ['Motors', 'Electronics', 'Collectibles & Art', 'Home & Garden', 'Clothing, Shoes & Accessories', 'Toys & Hobbies', 'Sporting Goods', 'Books, Movies & Music', 'Health & Beauty', 'Business & Industrial', 'Jewelry & Watches', 'Baby Essentials', 'Pet Supplies']
    carouselItems.forEach(function(item) {
        item.addEventListener('click', function(event) {
            // Check if the click is not on a carousel control (prev/next button)
            if (event.target.tagName === 'IMG') {
                // Get the index of the clicked carousel item
                let index = Array.from(carouselItems).indexOf(item);
                // Redirect to the category page using the index or category name
                window.location.href = `/categories/category=${index}&order=desc`;
            }
        });
    });
});
