import "jquery";

// confirmation of item deletion from cart
// turbo:load instead of ready to work when navigating back to the page (e.g., using
// the back or forward buttons in the browser)
$(document).on('turbo:load', function() {
    $('.delete-item').click(function(event) {
        let productData = $(this).closest('tr').data('product');
        let productName = productData.name;
        $('#productNamePlaceholder').text(productName);
        let productId = productData.id;
        $('#productIdPlaceholder').val(productId);
    });
});




// dynamically changes cart price based on chosen shipping cost
$(document).on('turbo:load', function() {
        const expeditedShipping = document.getElementById("expedited-shipping");
        const regularShipping = document.getElementById("regular-shipping");

        if (expeditedShipping !== undefined && expeditedShipping !== null){
            expeditedShipping.addEventListener("change", updateCartPrice);
        }
        if (regularShipping !== undefined && regularShipping !== null) {
            regularShipping.addEventListener("change", updateCartPrice);
        }

    function updateCartPrice() {
        // Get the selected shipping option element
        const selectedShippingElement = document.querySelector('input[name="shipping"]:checked');

        // Check if an option is selected
        if (selectedShippingElement) {
            const selectedShipping = selectedShippingElement.value;
            const cartPriceElement = document.getElementById("cart-price");
            const cartPriceValue = cartPriceElement.dataset.cartPrice;
            const newCartPrice = parseFloat(cartPriceValue) + parseFloat(selectedShipping);
            cartPriceElement.textContent = "Total: $" + newCartPrice.toFixed(2);
            console.log(newCartPrice.toFixed(2));
        } else {
            console.log("No shipping option selected");
        }
    }
});

