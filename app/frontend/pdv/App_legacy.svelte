<script lang="ts">
  import { untrack } from "svelte";
  import type { Action } from "svelte/action";
  import Choices from "choices.js";
  import IMask from "imask";

  // Fetch Products
  type Product = {
    id: number;
    name: string;
    description: string;
    cost_price_cents: number;
    retail_price_cents: number;
    costPrice: number;
    retailPrice: number;
    createdAt: string;
    updatedAt: string;
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
          retailPriceCents: Number(product.retail_price_cents),
          costPriceCents: Number(product.cost_price_cents),
          retailPrice: Number(product.retail_price_cents) / 100,
          costPrice: Number(product.cost_price_cents) / 100,
        }));

        loading = false;
      })
      .catch((err) => {
        error = err;
        loading = false;
      });
  });

  // Cart logic
  type CartItem = {
    product: Product;
    quantity: number;
  };

  let cart: CartItem[] = $state([]);
  let cartTotalAmountCents = $derived.by(() => {
    return cart.reduce((total, item) => {
      return total + item.product.retail_price_cents * item.quantity;
    }, 0);
  });
  let cartTotalAmount = $derived(cartTotalAmountCents / 100);

  function addToCart(product: Product) {
    const existingItem = cart.find((item) => item.product.id === product.id);
    if (existingItem) {
      existingItem.quantity += 1;
    } else {
      cart = [...cart, { product, quantity: 1 }];
    }
  }

  function removeFromCart(product: Product) {
    const existingItem = cart.find((item) => item.product.id === product.id);
    if (existingItem) {
      if (existingItem.quantity === 1) {
        cart = cart.filter((item) => item.product.id !== product.id);
      } else {
        existingItem.quantity -= 1;
      }
    }
  }

  // Current payments
  type PaymentMethod = {
    id: number;
    name: string;
  };

  type Payment = {
    id: number;
    paymentMethod: PaymentMethod;
    amountCents: number;
    amount: number;
  };

  let paymentMethods: PaymentMethod[] = $state([]);
  let selectedPaymentMethod: PaymentMethod | null = $state(null);
  let currentPayments: Payment[] = $state([]);
  let paymentInputAmount: number = $state(0);
  let cartAmountDueCents = $derived.by(() => {
    // Calculate the total amount of current payments
    const totalPayments = currentPayments.reduce((total, payment) => {
      return total + payment.amountCents;
    }, 0);

    // Calculate the remaining amount due
    return cartTotalAmountCents - totalPayments;
  });
  let cartAmountDue = $derived(cartAmountDueCents / 100);

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

  function addPayment(paymentMethod: PaymentMethod, amount: number) {
    currentPayments = [
      ...currentPayments,
      {
        id: currentPayments.length + 1,
        paymentMethod: paymentMethod,
        amountCents: amount,
        amount: amount / 100,
      },
    ];
  }

  function removePayment(currentPayment: Payment) {
    currentPayments = currentPayments.filter(
      (payment) => payment.id !== currentPayment.id
    );
  }

  // Use imask on the payment input
  const inputMask: Action = (node) => {
    $effect(() => {
      const maskOptions = {
        mask: "R$ num",
        blocks: {
          num: {
            mask: Number, // enable number mask
            // other options are optional with defaults below
            scale: 2, // digits after point, 0 for integers
            thousandsSeparator: " ", // any single char
            padFractionalZeros: false, // if true, then pads zeros at end to the length of scale
            normalizeZeros: true, // appends or removes zeros at ends
            radix: ",", // fractional delimiter
            mapToRadix: ["."], // symbols to process as radix
            lazy: false,

            min: 0,
            max: 99999,
            autofix: true,
          },
        },
      };

      const mask = IMask(node, maskOptions);

      // This being inside an $effect makes it reactive
      mask.unmaskedValue = String(paymentInputAmount);

      // Untrack to avoid circular assignment
      untrack(() => {
        // 'accept' event fired on input when mask value has changed
        mask.on("accept", () => {
          paymentInputAmount = Number(mask.unmaskedValue);
        });
      });

      return () => {
        mask.destroy();
      };
    });
  };

  $inspect(paymentInputAmount);

  // Customer
  type Customer = {
    id: number;
    name: string;
    address: string;
    createdAt: string;
    updatedAt: string;
  };

  let customers: Customer[] = $state([]);
  let selectedCustomerId: number | null = $state(null);

  $effect(() => {
    fetch("/customers.json")
      .then((response) => {
        if (!response.ok) {
          throw new Error("Network response was not ok");
        }
        return response.json();
      })
      .then((data: Customer[]) => {
        customers = data;
        loading = false;
      })
      .catch((err) => {
        error = err;
        loading = false;
      });
  });

  let choices;

  const initChoices: Action = (node) => {
    // the node has been mounted in the DOM
    choices = new Choices("#customer-select", {
      searchEnabled: true, // Enable search functionality
      placeholderValue: "Select a customer", // Placeholder text
      removeItemButton: true, // Allow items to be removed
      renderChoiceLimit: 5,
    });
  };

  $effect(() => {
    choices.setChoices([
      ...customers.map((customer) => ({
        value: customer.id,
        label: customer.name,
      })),
    ]);
  });

  // Finalize sale
  type FiscalDocument = {
    fiscal_document: {
      customer_id: number;
      description: string;
      document_items_attributes: {
        product_id: number;
        quantity: number;
      }[];
      document_payments_attributes: {
        payment_method_id: number;
        amount_cents: number;
      }[];
    };
  };
  let fiscalDocument: FiscalDocument | null = $state(null);

  function finalizeSale() {
    fiscalDocument = {
      fiscal_document: {
        customer_id: selectedCustomerId,
        description: "Venda de Mercadorias",
        document_items_attributes: cart.map((item) => ({
          product_id: item.product.id,
          quantity: item.quantity,
        })),
        document_payments_attributes: currentPayments.map((payment) => ({
          payment_method_id: payment.paymentMethod.id,
          amount_cents: payment.amountCents,
        })),
      },
    };

    console.log($state.snapshot(fiscalDocument));
    const csrfToken = document
      .querySelector('meta[name="csrf-token"]')
      .getAttribute("content");

    fetch("/fiscal_documents", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json",
        "X-CSRF-Token": csrfToken,
      },
      body: JSON.stringify(fiscalDocument),
    })
      .then((response) => {
        if (!response.ok) {
          // If response is not ok, throw an error to be caught in the catch block
          throw new Error("Houve um erro!");
        }
        return response.json(); // Parse the JSON from the response
      })
      .then((data) => {
        console.log(data); // Log the data on success
        cart = [];
        currentPayments = [];
        // open in a new tab the fiscal_document page
        window.open(`/fiscal_documents/${data.id}`, "_blank");
      })
      .catch((error) => {
        alert(error); // Alert the error message on failure
      });
  }
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
      <li><a class="dropdown-item" href="/fiscal_documents">Vendas</a></li>
    </ul>
  </div>
</header>

<div class="container-fluid">
  <div class="row">
    <!-- Product Panel -->
    <div class="col-md-6">
      <h2 class="text-center my-3">Produtos</h2>
      <div class="row">
        {#each products as product}
          <button
            class="col-6 col-sm-4 mb-4 btn"
            onclick={() => addToCart(product)}
          >
            <div class="card">
              <!-- Assuming product has an image_url attribute -->
              <img
                src="https://placehold.co/80"
                class="card-img-top"
                alt="<%= product.name %>"
              />
              <div class="card-body">
                <!-- Assuming product has a name attribute -->
                <h5 class="card-title">{product.name}</h5>
                <!-- Assuming product has a description attribute -->
                <p class="card-text">R$ {product.retailPrice}</p>
              </div>
            </div>
          </button>
        {/each}
      </div>
    </div>

    <!-- Cart Panel -->
    <div class="col-md-6">
      <h2 class="text-center my-3">Cesta</h2>
      <ul class="list-group">
        <!-- Cart Item -->
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
                onclick={() => removeFromCart(item.product)}
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
  </div>
</div>

<!-- Offcanvas Finalizar Venda -->
<div
  class="offcanvas offcanvas-end"
  tabindex="-1"
  id="offcanvasSale"
  aria-labelledby="offcanvasSaleLabel"
  style="width: 60%"
>
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="offcanvasSaleLabel">Finalizar Venda</h5>
    <button
      type="button"
      class="btn-close"
      data-bs-dismiss="offcanvas"
      aria-label="Close"
    ></button>
  </div>
  <div class="offcanvas-body bg-secondary-subtle">
    <div class="row">
      <div class="col-md-6">
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
                  selectedPaymentMethod = paymentMethod;
                  paymentInputAmount === 0 || paymentInputAmount === null
                    ? (paymentInputAmount = cartAmountDue)
                    : paymentInputAmount;
                }}
              >
                <div class="">
                  <h5 class="">
                    {paymentMethod.name}
                  </h5>
                  <div class="d-flex justify-content-center">
                    <i class="bi bi-credit-card" style="font-size: 3rem;"></i>
                  </div>
                </div>
              </button>
            {/each}
          </div>
          <div class="mt-3">
            <input
              use:inputMask
              id="payment-amount-input"
              class="form-control"
            />
            <button
              class="btn btn-primary"
              type="button"
              disabled={!selectedPaymentMethod || paymentInputAmount <= 0}
              onclick={() => {
                addPayment(selectedPaymentMethod, paymentInputAmount * 100);
                selectedPaymentMethod = null;
                paymentInputAmount = 0;
              }}
            >
              Adicionar Pagamento
            </button>
          </div>
        </div>

        <div>
          <select
            use:initChoices
            id="customer-select"
            class=""
            bind:value={selectedCustomerId}
          >
          </select>
        </div>
      </div>
      <div class="col-md-6">
        <div class="container-fluid">
          <h4>Resumo da Venda</h4>
          <div class="row">
            <div class="col">
              <h5>Total:</h5>
              <p>{cartTotalAmount}</p>
            </div>
            <div class="col">
              <h5>Saldo:</h5>
              <p>
                {cartAmountDue}
              </p>
            </div>
          </div>
          <ul class="list-group">
            {#each currentPayments as payment}
              <li
                class="list-group-item d-flex justify-content-between align-items-center text-center"
              >
                <div>
                  {payment.paymentMethod.name}
                </div>
                <div class="d-flex align-items-center gap-3">
                  <span class="badge rounded-pill text-bg-primary"
                    >${payment.amount}</span
                  >
                  <button
                    class="btn btn-sm btn-danger"
                    type="button"
                    aria-label="Remove payment"
                    onclick={() => removePayment(payment)}
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
              onclick={finalizeSale}
            >
              Finalizar Venda
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
