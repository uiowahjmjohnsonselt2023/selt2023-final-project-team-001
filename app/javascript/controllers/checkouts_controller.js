import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [
        "hiddenCartItemField",
        "totalPrice",
        "shipping",
        "shippingSelect",
        "deleteProductName"
    ];
    static values = { cartPrice: Number };

    updateDeleteModal({ params: { cartItemId, productName } }) {
        this.hiddenCartItemFieldTarget.value = cartItemId;
        this.deleteProductNameTarget.textContent = productName;
    }

    shippingSelectTargetConnected(target) {
        const radio = target.querySelector("input:checked");
        radio.checked = false;
        radio.click(); // This will trigger the updateShipping method
    }

    updateShipping(event) {
        const selectedShipping = event.target.value;
        this.shippingTarget.textContent = "$" + selectedShipping;
        const newCartPrice = this.cartPriceValue + parseFloat(selectedShipping);
        this.totalPriceTarget.textContent = "$" + newCartPrice.toFixed(2);
    }
}
