<script setup lang="ts">
import { onBeforeMount, onBeforeUnmount, onMounted, watchEffect } from "vue";
import ProductSearch from "./ProductSearch.vue";
import { products } from "../lib/saleStore";
</script>

<template>
  <header class="p-3 text-bg-primary d-flex justify-content-between">
    <div class="dropdown">
      <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        Mais
      </button>
      <ul class="dropdown-menu">
        <li><a class="dropdown-item" href="/">Home</a></li>
        <li><a class="dropdown-item" href="/products">Produtos</a></li>
        <li><a class="dropdown-item" href="/fiscal_documents">Vendas</a></li>
      </ul>
    </div>
    <div>
      <ProductSearch />
    </div>
  </header>
</template>
