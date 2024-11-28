import { Controller } from "@hotwired/stimulus";
import { Toast } from "bootstrap";

export default class extends Controller {
  static targets = ["toast"];
  connect() {
    if (this.hasToastTarget) {
      const toast = Toast.getOrCreateInstance(this.toastTarget);
      toast.show();
    }
  }
}
