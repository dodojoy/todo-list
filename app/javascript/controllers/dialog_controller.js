import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dialog"];

  connect() {
    this.dialogTarget.addEventListener("click", (e) => {
      if (e.target === this.dialogTarget) {
        this.close();
      }
    });

    this.dialogTarget.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        this.close();
      }
    });
  }

  close() {
    if (this.dialogTarget.open) {
      this.dialogTarget.close();
    }
  }
}
