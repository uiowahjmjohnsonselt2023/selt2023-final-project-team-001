import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["hiddenMessageField"];

    updateDeleteModal({ params: { messageId } }) {
        this.hiddenMessageFieldTarget.value = messageId;
    }

}
