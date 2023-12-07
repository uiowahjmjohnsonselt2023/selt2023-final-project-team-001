import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["path"];

    search(event) {
        const path = this.pathTarget.value;
        event.target.action = path;
    }
}
