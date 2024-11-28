import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.debounceTimeout = null;
  }

  debouncedSubmit() {
    // Clear the previous timeout if it exists
    clearTimeout(this.debounceTimeout);

    // Set a new timeout to submit the form after 2 seconds
    this.debounceTimeout = setTimeout(() => {
      this.element.requestSubmit(); // Submit the form
    }, 500);
  }
}
