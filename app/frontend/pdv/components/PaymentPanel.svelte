<script lang="ts">
  import { untrack } from "svelte";
  import type { Action } from "svelte/action";
  import type { PaymentMethod } from "../lib/types";
  import IMask from "imask";

  let {
    paymentMethods,
    selectedPaymentMethod,
    paymentInputAmount,
    cartAmountDue,
    onSelectPaymentMethod,
    onAddPayment,
  }: {
    paymentMethods: PaymentMethod[];
    selectedPaymentMethod: PaymentMethod | null;
    paymentInputAmount: number;
    cartAmountDue: number;
    onSelectPaymentMethod: (method: PaymentMethod) => void;
    onAddPayment: (method: PaymentMethod, amount: number) => void;
  } = $props();

  const inputMask: Action = (node) => {
    $effect(() => {
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

      const mask = IMask(node, maskOptions);
      mask.unmaskedValue = String(paymentInputAmount);

      untrack(() => {
        mask.on("accept", () => {
          paymentInputAmount = Number(mask.unmaskedValue);
        });
      });

      return () => {
        mask.destroy();
      };
    });
  };
</script>

<div class="container-fluid mb-3">
  {#if selectedPaymentMethod}
    <h4>{selectedPaymentMethod.name}</h4>
  {:else}
    <h4>Selecione um meio de pagamento</h4>
  {/if}

  <div
    class="row row-cols-1 row-cols-md-2 g-2 overflow-auto"
    style="max-height: 300px;"
  >
    {#each paymentMethods as paymentMethod}
      <button
        class="btn btn-primary col"
        onclick={() => {
          onSelectPaymentMethod(paymentMethod);
          if (paymentInputAmount === 0 || paymentInputAmount === null) {
            paymentInputAmount = cartAmountDue;
          }
        }}
      >
        <div class="">
          <h5 class="">{paymentMethod.name}</h5>
          <div class="d-flex justify-content-center">
            <i class="bi bi-credit-card" style="font-size: 3rem;"></i>
          </div>
        </div>
      </button>
    {/each}
  </div>
  <div class="mt-3">
    <input use:inputMask id="payment-amount-input" class="form-control" />
    <button
      class="btn btn-primary"
      type="button"
      disabled={!selectedPaymentMethod || paymentInputAmount <= 0}
      onclick={() => {
        onAddPayment(selectedPaymentMethod, paymentInputAmount * 100);
        selectedPaymentMethod = null;
        paymentInputAmount = 0;
      }}
    >
      Adicionar Pagamento
    </button>
  </div>
</div>
