<template>
  <Header />

  <div class="container-fluid">
    <div class="row">
      <ProductPanel />
      <CartPanel />
    </div>
  </div>

  <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasSale" aria-labelledby="offcanvasSaleLabel"
    style="width: 60%">
    <div class="offcanvas-header">
      <h5 class="offcanvas-title" id="offcanvasSaleLabel">Finalizar Venda</h5>
      <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
    </div>
    <div class="offcanvas-body bg-secondary-subtle">
      <div class="row">
        <div class="col-md-6">
          <PaymentPanel />
          <CustomerSelect />
        </div>
        <div class="col-md-6">
          <SaleSummary />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import Header from "./components/Header.vue";
import ProductPanel from "./components/ProductPanel.vue";
import CartPanel from "./components/CartPanel.vue";
import PaymentPanel from "./components/PaymentPanel.vue";
import CustomerSelect from "./components/CustomerSelect.vue";
import SaleSummary from "./components/SaleSummary.vue";
import { initializeSales } from "./lib/saleStore";

initializeSales()
</script>

<style scoped>
.container-fluid {
  margin-top: 20px;
}
</style>
