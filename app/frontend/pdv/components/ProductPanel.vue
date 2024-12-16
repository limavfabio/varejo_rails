<template>
  <div class="col-md-6">
    <h2 class="text-center my-3">Produtos</h2>
    <div class="row">
      <div v-if="products.loading" class="col-12">Carregando...</div>
      <button v-else v-for="product in products.data" :key="product.id" class="col-6 col-sm-4 mb-4 btn"
        @click="addToCart(product)">
        <div class="card">
          <img src="https://placehold.co/80" class="card-img-top" :alt="product.name" />
          <div class="card-body">
            <h5 class="card-title">{{ product.name }}</h5>
            <p class="card-text">R$ {{ product.retailPrice }}</p>
          </div>
        </div>
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import type { Product } from '../lib/types';
import { products, cart } from '../lib/saleStore';
import { addToCart } from '../lib/actions';

</script>
