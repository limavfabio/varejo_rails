import { Application } from "@hotwired/stimulus";

import ToastController from "../controllers/toast_controller";
import SearchController from "../controllers/search_controller";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

Stimulus.register("toast", ToastController);
Stimulus.register("search", SearchController);

console.log("Stimulus is ready");
