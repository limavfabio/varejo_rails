import { Application } from "@hotwired/stimulus";

import ToastController from "../controllers/toast_controller";
import SearchFormController from "../controllers/search_form_controller";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

Stimulus.register("toast", ToastController);
Stimulus.register("search_form", SearchFormController);

console.log("Stimulus is ready");
