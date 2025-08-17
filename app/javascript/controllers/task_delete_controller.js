import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String,
  };

  //   static targets = ["form"];

  connect() {
    this.element.addEventListener("click", this.loadAndShowModal.bind(this));

    const dialog = document.querySelector("#delete_task_dialog");
    if (dialog) {
      const observer = new MutationObserver(() => {
        dialog.close();
      });
      observer.observe(dialog, { childList: true });
    }
  }

  loadAndShowModal(event) {
    event.stopPropagation();
    const dialog = document.querySelector("#delete_task_dialog");
    if (dialog) {
      const form = dialog.querySelector("form");
      if (form) {
        form.action = `/tasks/${this.idValue}`;
        form.dataset.turboFrame = `task_${this.idValue}`;
      }
      dialog.showModal();
    }
  }
}
