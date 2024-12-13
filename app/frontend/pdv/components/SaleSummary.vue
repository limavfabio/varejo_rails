<template>
  <div class="container-fluid">
    <h4>Resumo da Venda</h4>
    <div class="row">
      <div class="col">
        <h5>Total:</h5>
        <p>{{ cartTotalAmount }}</p>
      </div>
      <div class="col">
        <h5>Saldo:</h5>
        <p>{{ cartAmountDue }}</p>
      </div>
    </div>
    <ul class="list-group">
      <li v-for="payment in currentPayments" :key="payment.id"
        class="list-group-item d-flex justify-content-between align-items-center text-center">
        <div>{{ payment.paymentMethod.name }}</div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge rounded-pill text-bg-primary">
            ${{ payment.amount }}
          </span>
          <button class="btn btn-sm btn-danger" type="button" aria-label="Remove payment"
            @click="removePayment(payment)">
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </li>
    </ul>
    <div class="mt-3">
      <button class="btn btn-primary" type="button" data-bs-dismiss="offcanvas" aria-label="Close"
        :disabled="cartAmountDue > 0" @click="finalizeSale">
        Finalizar Venda
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { Payment } from '../lib/types';
import { cartTotalAmount, cartAmountDue, currentPayments, cart, selectedCustomerId } from '../lib/saleStore';
import type { FiscalDocument } from '../lib/types';

function removePayment(payment: Payment) {
  currentPayments.value = currentPayments.value.filter((p) => p.id !== payment.id);
}

function finalizeSale() {
  const fiscalDocument: FiscalDocument = {
    fiscal_document: {
      customer_id: selectedCustomerId.value,
      description: "Venda de Mercadorias",
      document_items_attributes: cart.value.map((item) => ({
        product_id: item.product.id,
        quantity: item.quantity,
      })),
      document_payments_attributes: currentPayments.value.map((payment) => ({
        payment_method_id: payment.paymentMethod.id,
        amount_cents: payment.amountCents,
      })),
    },
  };

  const csrfToken = document
    .querySelector('meta[name="csrf-token"]')
    ?.getAttribute("content");

  fetch("/fiscal_documents", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Accept: "application/json",
      "X-CSRF-Token": csrfToken || "",
    },
    body: JSON.stringify(fiscalDocument),
  })
    .then((response) => {
      if (!response.ok) {
        throw new Error("Houve um erro!");
      }
      return response.json();
    })
    .then((data) => {
      cart.value = [];
      currentPayments.value = [];
      window.open(`/fiscal_documents/${data.id}`, "_blank");
    })
    .catch((error) => {
      alert(error);
    });
}
</script>
