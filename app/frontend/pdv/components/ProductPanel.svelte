<script lang="ts">
  import type { Product } from "../lib/types";

  let {
    products,
    onAddToCart,
  }: {
    products: Product[];
    onAddToCart: (product: Product) => void;
  } = $props();
</script>

<div class="col-md-6">
  <h2 class="text-center my-3">Produtos</h2>
  <div class="row">
    {#each products as product}
      <button
        class="col-6 col-sm-4 mb-4 btn"
        onclick={() => onAddToCart(product)}
      >
        <div class="card">
          <img
            src="https://placehold.co/80"
            class="card-img-top"
            alt={product.name}
          />
          <div class="card-body">
            <h5 class="card-title">{product.name}</h5>
            <p class="card-text">R$ {product.retailPrice}</p>
          </div>
        </div>
      </button>
    {/each}
  </div>
</div>
