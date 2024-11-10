import { mount } from "svelte";
import App from "~/pdv/App.svelte";

const app = mount(App, {
  target: document.getElementById("svelte-app"),
});

export default app;
