<script lang="ts">
  import type { Action } from "svelte/action";
  import type { Customer } from "../lib/types";
  import Choices from "choices.js";

  let {
    customers,
    selectedCustomerId = $bindable(),
  }: { customers: Customer[]; selectedCustomerId: number | null } = $props();

  let choices: Choices;

  const initChoices: Action = (node) => {
    choices = new Choices("#customer-select", {
      searchEnabled: true,
      placeholderValue: "Select a customer",
      removeItemButton: true,
      renderChoiceLimit: 5,
    });

    return {
      destroy() {
        choices.destroy();
      },
    };
  };

  $effect(() => {
    if (choices) {
      choices.setChoices(
        customers.map((customer) => ({
          value: customer.id,
          label: customer.name,
        }))
      );
    }
  });
</script>

<div>
  <select
    use:initChoices
    id="customer-select"
    class=""
    bind:value={selectedCustomerId}
  >
  </select>
</div>
