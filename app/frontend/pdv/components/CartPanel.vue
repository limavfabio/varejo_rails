<template>
  <div class="col-md-6">
    <h2 class="text-center my-3">Cesta</h2>
    <ul class="list-group">
      <li v-for="item in cart" :key="item.product.id"
        class="list-group-item d-flex justify-content-between align-items-center text-center">
        <div>
          {{ item.product.name }}
          <span class="badge rounded-pill text-bg-secondary">
            {{ item.quantity }}
          </span>
        </div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge rounded-pill text-bg-primary">
            ${{ item.product.retailPrice }}
          </span>
          <button class="btn btn-sm btn-danger" type="button" aria-label="Remove product from cart"
            @click="removeFromCart(item.product)">
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </li>
    </ul>
    <div class="mt-3">
      <h4>{{ cartTotalAmount }}</h4>
      <button class="btn btn-primary" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasSale"
        aria-controls="offcanvasSale">
        Finalizar Venda
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { cart, cartTotalAmount } from '../lib/saleStore';
import type { Product } from '../lib/types';

function removeFromCart(product: Product) {
  const existingItem = cart.value.find((item) => item.product.id === product.id);
  if (existingItem) {
    if (existingItem.quantity === 1) {
      cart.value = cart.value.filter((item) => item.product.id !== product.id);
    } else {
      existingItem.quantity -= 1;
    }
  }
}

</script>
