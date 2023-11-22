
// confirmation of item deletion from cart
$(document).ready(function() {
    // Show the confirmation modal when the "Delete" button is clicked
    $('.delete-item').click(function(event) {
        event.preventDefault(); // Prevent the default form submission
        $('#confirmationModal').modal('show');
    });

    $('#confirmationModal').on('show.bs.modal', function(event) {
        const form = $('.delete-item');
        const originalAction = form.attr('action');
        const actionWithConfirmation = originalAction + '?confirmation=yes';
        form.attr('action', actionWithConfirmation);
    });

    // Handle the "Delete" link click in the modal
    $('#confirmDeleteLink').click(function(event) {
        event.preventDefault(); // Prevent the default form submission
        $('.delete-item').submit();
    });
});

// dynamically changes cart price based on chosen shipping cost
$(document).ready(function() {
        const expeditedShipping = document.getElementById("expedited-shipping");
        const regularShipping = document.getElementById("regular-shipping");

        expeditedShipping.addEventListener("change", updateCartPrice);
        regularShipping.addEventListener("change", updateCartPrice);

    function updateCartPrice() {
        // Get the selected shipping option element
        const selectedShippingElement = document.querySelector('input[name="shipping"]:checked');

        // Check if an option is selected
        if (selectedShippingElement) {
            const selectedShipping = selectedShippingElement.value;
            const cartPriceElement = document.getElementById("cart-price");
            const cartPriceValue = cartPriceElement.dataset.cartPrice;
            const newCartPrice = parseFloat(cartPriceValue) + parseFloat(selectedShipping);
            cartPriceElement.textContent = "$" + newCartPrice.toFixed(2);
            console.log(newCartPrice.toFixed(2));
        } else {
            console.log("No shipping option selected");
        }
    }
});

// display product name in modal
$(document).ready(function() {
    $('.delete-item').on('click', function() {
        var productName = $(this).data('productName');
        $('#productNamePlaceholder').text(productName);
    });
});
