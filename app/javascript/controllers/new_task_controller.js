import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["dialog"];

  showModal() {
    const dialog = document.querySelector("#new_task_dialog");
    if (dialog) {
      dialog.showModal();
    }
  }

  close() {
    if (this.dialogTarget.open) {
      this.dialogTarget.close();
      this.dispatch("closed");
    }
  }
}
