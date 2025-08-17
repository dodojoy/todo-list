import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    id: String,
  };

  connect() {
    this.element.addEventListener("click", this.loadAndShowModal.bind(this));
  }

  async loadAndShowModal(event) {
    if (event.target.type === "checkbox") return;

    if (event.target.closest("#delete-task-btn")) {
      const dialog = this.dialogTarget;
      if (dialog) {
        dialog.showModal();
      }
      return;
    }

    try {
      const response = await fetch(`/tasks/${this.idValue}/edit`, {
        headers: {
          Accept: "text/html",
          "X-Requested-With": "XMLHttpRequest",
        },
      });

      if (response.ok) {
        const html = await response.text();
        const dialogContent = document.querySelector("#edit-dialog-content");
        if (dialogContent) {
          dialogContent.innerHTML = html;
          const dialog = document.querySelector("#edit_task_dialog");
          if (dialog) {
            dialog.showModal();
          }
        }
      }
    } catch (error) {
      console.error("Error loading task:", error);
    }
  }
}
