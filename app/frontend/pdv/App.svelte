<script lang="ts">
  // Fetch Products
  type Product = {
    id: number;
    name: string;
    description: string;
    cost_price: number;
    retail_price: number;
    created_at: string;
    updated_at: string;
  };

  let products: Product[] = $state([]);
  let loading = $state(true);
  let error = $state(null);

  $effect(() => {
    fetch("/products.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data: Product[]) => {
        products = data;
        products = products.map((product) => ({
          ...product,
          retail_price: Number(product.retail_price),
          cost_price: Number(product.cost_price),
        }));

        loading = false;
      })
      .catch((err) => {
        error = err;
        loading = false;
      });
  });

  // Cart logic
  let cart: Product[] = $state([]);
  let cartTotal = $derived.by(() => {
    return cart.reduce((total, product) => {
      return total + product.retail_price;
    }, 0);
  });

  function addToCart(product: Product) {
    cart = [...cart, product];
  }

  // Current payments
  type PaymentMethod = {
    id: number;
    name: string;
  };

  let paymentMethods: PaymentMethod[] = $state([]);

  $effect(() => {
    fetch("/payment_methods.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data: PaymentMethod[]) => {
        paymentMethods = data;

        loading = false;
      })
      .catch((err) => {
        error = err;
        loading = false;
      });
  });
</script>

<header class="p-3 text-bg-primary">
  <div class="dropdown">
    <button
      class="btn btn-secondary dropdown-toggle"
      type="button"
      data-bs-toggle="dropdown"
      aria-expanded="false"
    >
      Mais
    </button>
    <ul class="dropdown-menu">
      <li><a class="dropdown-item" href="/">Home</a></li>
      <li><a class="dropdown-item" href="/products">Produtos</a></li>
    </ul>
  </div>
</header>

<div class="container">
  <div class="row">
    <!-- Product Panel -->
    <div class="col-md-6 border-right">
      <h2 class="text-center my-3">Produtos</h2>
      <div class="list-group">
        <!-- Example Product Item -->
        {#each products as product}
          <button
            onclick={() => addToCart(product)}
            type="button"
            class="list-group-item list-group-item-action"
          >
            {product.name} - ${product.retail_price}
          </button>
        {/each}
      </div>
    </div>

    <!-- Cart Panel -->
    <div class="col-md-6">
      <h2 class="text-center my-3">Cesta</h2>
      <ul class="list-group">
        <!-- Cart Item -->
        {#each cart as product}
          <li
            class="list-group-item d-flex justify-content-between align-items-center"
          >
            {product.name}
            <span class="badge badge-primary badge-pill"
              >${product.retail_price}</span
            >
          </li>
        {/each}
      </ul>
      <div class="mt-3">
        <h4>{cartTotal}</h4>
        <button
          class="btn btn-primary"
          type="button"
          data-bs-toggle="offcanvas"
          data-bs-target="#offcanvasExample"
          aria-controls="offcanvasExample"
        >
          Finalizar Venda
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Offcanvas Finalizar Venda -->
<div
  class="offcanvas offcanvas-end"
  tabindex="-1"
  id="offcanvasExample"
  aria-labelledby="offcanvasExampleLabel"
>
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasExampleLabel">Finalizar Venda</h5>
    <button
      type="button"
      class="btn-close"
      data-bs-dismiss="offcanvas"
      aria-label="Close"
    ></button>
  </div>
  <div class="offcanvas-body">
    <div class="row">
      <div class="col-md-6">Painel 1</div>
      <div class="col-md-6">Painel 2</div>
    </div>
  </div>
</div>
