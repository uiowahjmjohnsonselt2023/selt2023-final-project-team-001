import { Controller } from "@hotwired/stimulus"

// PromotionFormController
export default class extends Controller {
    static targets = ["promotionType", "typeForm"];

    promotionTypeTargetConnected(target) {
        if (target.value !== "") {
            this.updateType();
        }
    }

    updateType() {
        const type = this.promotionTypeTarget.value;
        this.typeFormTargets.forEach((el) => {
            el.classList.toggle("d-none", el.dataset.type !== type);
            Array.from(el.getElementsByTagName("input")).forEach((input) => {
                // Disable all inputs that are not in the current type form
                // so that they are not submitted with the form.
                input.disabled = el.dataset.type !== type;
            });
        });
    }
}
