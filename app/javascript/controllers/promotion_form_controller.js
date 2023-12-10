import { Controller } from "@hotwired/stimulus"

// PromotionFormController
export default class extends Controller {
    static targets = ["promotionType", "typeForm"];

    connect() {
        console.log("Connected PromotionFormController", this);
    }

    promotionTypeTargetConnected(target) {
        console.log("Connected promotionTypeTarget", target);
        if (target.value !== "") {
            this.updateType();
        }
    }

    updateType() {
        const type = this.promotionTypeTarget.value;
        console.log("updateType", type);
        console.log(
            "typeFormTargets",
            this.typeFormTargets,
            this.typeFormTargets.map((el) => el.dataset.type)
        );
        this.typeFormTargets.forEach((el) => {
            el.classList.toggle("d-none", el.dataset.type !== type)
        });
    }
}
