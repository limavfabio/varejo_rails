<template>
  <div class="container-fluid mb-3">
    <h4>{{ selectedPaymentMethod ? selectedPaymentMethod.name : 'Selecione um meio de pagamento' }}</h4>

    <div class="row row-cols-1 row-cols-md-2 g-2 overflow-auto" style="max-height: 300px;">
      <button v-for="paymentMethod in paymentMethods.data" :key="paymentMethod.id" class="btn btn-primary col"
        @click="selectPaymentMethod(paymentMethod)">
        <div>
          <h5>{{ paymentMethod.name }}</h5>
          <div class="d-flex justify-content-center">
            <i class="bi bi-credit-card" style="font-size: 3rem;"></i>
          </div>
        </div>
      </button>
    </div>
    <div class="mt-3">
      <input id="payment-amount-input" class="form-control" />
      <button class="btn btn-primary" type="button" :disabled="!selectedPaymentMethod || paymentInputAmount <= 0"
        @click="() =>
          selectedPaymentMethod && addPayment(selectedPaymentMethod, paymentInputAmount * 100)">
        Adicionar Pagamento
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch, useTemplateRef, watchEffect, onWatcherCleanup, onUnmounted, onBeforeUnmount } from 'vue';
import IMask from 'imask';
import type { PaymentMethod, Payment } from '../lib/types';
import {
  paymentMethods,
  selectedPaymentMethod, paymentInputAmount, cartAmountDue, currentPayments
} from '../lib/saleStore';


function addPayment(paymentMethod: PaymentMethod, amount: number) {
  currentPayments.value.push({
    id: currentPayments.value.length + 1,
    paymentMethod,
    amountCents: amount,
    amount: amount / 100,
  });

  paymentInputAmount.value = 0;
  selectedPaymentMethod.value = null;
}

function selectPaymentMethod(method: PaymentMethod) {
  selectedPaymentMethod.value = method;
  if (paymentInputAmount.value === 0) {
    paymentInputAmount.value = cartAmountDue.value;
  }
}

onMounted(() => {
  const maskOptions = {
    mask: "R$ num",
    blocks: {
      num: {
        mask: Number,
        scale: 2,
        thousandsSeparator: " ",
        padFractionalZeros: false,
        normalizeZeros: true,
        radix: ",",
        mapToRadix: ["."],
        lazy: false,
        min: 0,
        max: 99999,
        autofix: true,
      },
    },
  };

  const paymentAmountInput = document.getElementById("payment-amount-input") as HTMLInputElement;
  const mask = IMask(paymentAmountInput, maskOptions);
  watch(paymentInputAmount, () => {
    mask.unmaskedValue = paymentInputAmount.value.toString();
  })

  mask.on("accept", () => {
    paymentInputAmount.value = Number(mask.unmaskedValue);
  });

  onBeforeUnmount(() => {
    mask.destroy();
  })
})
</script>
