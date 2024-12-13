<script setup lang="ts">
import { ref, watch, watchEffect } from 'vue'
import Fuse from 'fuse.js'
import type { Product } from '../lib/types'
import { products } from '../lib/saleStore'

// Emits
const emit = defineEmits<{
  (e: 'select', item: Product): void
}>()

// Estado local
const searchQuery = ref('')
const showDropdown = ref(false)
const filteredResults = ref<Product[]>([])

// Configuração do Fuse.js
const fuseOptions = {
  keys: ['name', 'description'],
  threshold: 0.3,
  // Ajuste estas opções conforme necessário
  includeScore: true,
  minMatchCharLength: 2
}

const fuse = new Fuse<Product>([], fuseOptions)

watchEffect(() => {
  fuse.setCollection(products.value.data)
})

// Observa mudanças na query de busca
watch(searchQuery, (newQuery) => {
  if (newQuery.trim()) {
    const results = fuse.search(newQuery)
    filteredResults.value = results
      .slice(0, 10) // Limita a 10 resultados
      .map(result => result.item)
  } else {
    filteredResults.value = []
  }
})

// Funções
const handleBlur = () => {
  // Pequeno delay para permitir que o click do item seja processado
  setTimeout(() => {
    showDropdown.value = false
  }, 200)
}

const selectItem = (item: Product) => {
  emit('select', item)
  searchQuery.value = ""
  showDropdown.value = false
}
</script>

<template>
  <div class="search-container position-relative">
    <input type="text" class="form-control" v-model="searchQuery" @focus="showDropdown = true"
      placeholder="Search..." />

    <div v-if="showDropdown && filteredResults.length > 0" class="dropdown-menu show w-100 position-absolute">
      <a v-for="item in filteredResults" :key="item.id" class="dropdown-item" href="#" @mousedown="selectItem(item)">
        {{ item.name }}
        <small class="text-muted d-block">{{ item.description }}</small>
      </a>
    </div>

    <div v-if="showDropdown && searchQuery && !filteredResults.length"
      class="dropdown-menu show w-100 position-absolute">
      <span class="dropdown-item-text">No results found</span>
    </div>
  </div>
</template>

<style scoped>
.search-container {
  /* Ajuste conforme necessário */
  max-width: 500px;
  margin: 0 auto;
}

.dropdown-menu {
  max-height: 300px;
  overflow-y: auto;
}

.dropdown-item {
  padding: 0.5rem 1rem;
  cursor: pointer;
}

.dropdown-item:hover {
  background-color: #f8f9fa;
}
</style>
