import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["form"];

  resetForm() {
    if (this.hasFormTarget) {
      this.formTarget.reset();
      this.formTarget.dispatchEvent(new CustomEvent("form:reset"));
    }
  }
}
