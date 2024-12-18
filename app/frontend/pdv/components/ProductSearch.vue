<script setup lang="ts">
import { onMounted, onWatcherCleanup, ref, useTemplateRef, watch, watchEffect } from 'vue'
import Fuse from 'fuse.js'
import type { Product } from '../lib/types'
import { products } from '../lib/saleStore'
import { addToCart } from '../lib/actions'

// Estado local
const searchQuery = ref('')
const showDropdown = ref(false)
const filteredResults = ref<Product[]>([])

const input = useTemplateRef('input')


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
  showDropdown.value = true
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
const selectItem = (item: Product) => {
  addToCart(item)
  searchQuery.value = ""
  // showDropdown.value = false
  input.value?.focus()
}

onMounted(() => {
  document.addEventListener('click', (event) => {
    const target = event.target as HTMLElement
    if (!target.closest('.search-container')) {
      showDropdown.value = false
    }
  })

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      showDropdown.value = false
    }
  })

  // if (!input.value) return
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Enter') {
      if (input.value === document.activeElement) {
        if (filteredResults.value.length > 0) {
          selectItem(filteredResults.value[0])
        }
      }
    }
  })

})
</script>

<template>
  <div class="search-container position-relative">
    <input ref="input" type="text" class="form-control" v-model="searchQuery" @focus="showDropdown = true"
      placeholder="Search..." />

    <div v-if="showDropdown && filteredResults.length > 0" class="dropdown-menu show w-100 position-absolute">
      <a v-for="item in filteredResults" :key="item.id" class="dropdown-item" href="#" @click="selectItem(item)">
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
