<script lang="ts">
  import type { CartItem, Product } from "../lib/types";

  let {
    cart,
    cartTotalAmount,
    onRemoveFromCart,
  }: {
    cart: CartItem[];
    cartTotalAmount: number;
    onRemoveFromCart: (product: Product) => void;
  } = $props();
</script>

<div class="col-md-6">
  <h2 class="text-center my-3">Cesta</h2>
  <ul class="list-group">
    {#each cart as item}
      <li
        class="list-group-item d-flex justify-content-between align-items-center text-center"
      >
        <div>
          {item.product.name}
          <span class="badge rounded-pill text-bg-secondary">
            {item.quantity}
          </span>
        </div>
        <div class="d-flex align-items-center gap-3">
          <span class="badge rounded-pill text-bg-primary"
            >${item.product.retailPrice}</span
          >
          <button
            class="btn btn-sm btn-danger"
            type="button"
            aria-label="Remove product from cart"
            onclick={() => onRemoveFromCart(item.product)}
          >
            <i class="bi bi-trash"></i>
          </button>
        </div>
      </li>
    {/each}
  </ul>
  <div class="mt-3">
    <h4>{cartTotalAmount}</h4>
    <button
      class="btn btn-primary"
      type="button"
      data-bs-toggle="offcanvas"
      data-bs-target="#offcanvasSale"
      aria-controls="offcanvasSale"
    >
      Finalizar Venda
    </button>
  </div>
</div>
