import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["hiddenProductField", "totalPrice"];
    static values = { cartPrice: Number };

    updateDeleteModal({ params: { productId } }) {
        this.hiddenProductFieldTarget.value = productId;
    }

    updateShipping(event) {
        const selectedShipping = event.target.value;
        const newCartPrice = this.cartPriceValue + parseFloat(selectedShipping);
        this.totalPriceTarget.textContent = "Total: $" + newCartPrice.toFixed(2);
    }
}
