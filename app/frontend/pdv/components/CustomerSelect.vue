<script setup lang="ts">
import { onBeforeMount, onBeforeUnmount, onMounted, watchEffect } from "vue";
import type { Customer } from "../lib/types";
import { customers, selectedCustomerId } from "../lib/saleStore";
import Choices from "choices.js";

let choices: Choices;

onMounted(() => {
  choices = new Choices("#customer-select", {
    searchEnabled: true,
    placeholderValue: "Select a customer",
    removeItemButton: true,
    renderChoiceLimit: 5,
  });

  watchEffect(() => {
    choices.setChoices(
      customers.value.data.map((customer) => ({
        value: customer.id,
        label: customer.name,
      }))
    );
  })

  onBeforeUnmount(() => {
    choices.destroy();
  })
})
</script>

<template>
  <div>
    <select id="customer-select" v-model="selectedCustomerId">
    </select>
  </div>
</template>
