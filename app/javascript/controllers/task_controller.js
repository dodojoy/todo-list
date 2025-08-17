import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "label", "dialog"];
  static values = {
    id: String,
  };

  connect() {
    if (this.hasLabelTarget) {
      this.toggle();
    }
  }

  toggle() {
    if (this.checkboxTarget.checked) {
      this.labelTarget.textContent = "Concluded";
    } else {
      this.labelTarget.textContent = "To do";
    }
  }

  save() {
    fetch(`/tasks/${this.element.dataset.id}`, {
      method: "PATCH",
      headers: { Accept: "text/vnd.turbo-stream.html" },
      body: JSON.stringify({
        task: {
          concluded: this.checkboxTarget.checked,
        },
      }),
    });
  }

  submit() {
    this.element.requestSubmit();
  }
}
