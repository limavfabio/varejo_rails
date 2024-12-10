<script lang="ts">
  import type { Payment } from "../lib/types";

  let {
    cartTotalAmount,
    cartAmountDue,
    currentPayments,
    onRemovePayment,
    onFinalizeSale,
  }: {
    cartTotalAmount: number;
    cartAmountDue: number;
    currentPayments: Payment[];
    onRemovePayment: (payment: Payment) => void;
    onFinalizeSale: () => void;
  } = $props();
</script>

<div class="container-fluid">
  <h4>Resumo da Venda</h4>
  <div class="row">
    <div class="col">
      <h5>Total:</h5>
      <p>{cartTotalAmount}</p>
    </div>
    <div class="col">
      <h5>Saldo:</h5>
      <p>{cartAmountDue}</p>
    </div>
  </div>
  <ul class="list-group">
    {#each currentPayments as payment}
      <li
        class="list-group-item d-flex justify-content-between align-items-center text-center"
      >
        <div>{payment.paymentMethod.name}</div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge rounded-pill text-bg-primary"
            >${payment.amount}</span
          >
          <button
            class="btn btn-sm btn-danger"
            type="button"
            aria-label="Remove payment"
            onclick={() => onRemovePayment(payment)}
          >
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </li>
    {/each}
  </ul>
  <div class="mt-3">
    <button
      class="btn btn-primary"
      type="button"
      data-bs-dismiss="offcanvas"
      aria-label="Close"
      disabled={cartAmountDue > 0}
      onclick={onFinalizeSale}
    >
      Finalizar Venda
    </button>
  </div>
</div>
