<script lang="ts">
  import Header from "./components/Header.svelte";
  import ProductPanel from "./components/ProductPanel.svelte";
  import CartPanel from "./components/CartPanel.svelte";
  import PaymentPanel from "./components/PaymentPanel.svelte";
  import CustomerSelect from "./components/CustomerSelect.svelte";
  import SaleSummary from "./components/SaleSummary.svelte";
  import type {
    Product,
    CartItem,
    Payment,
    PaymentMethod,
    Customer,
    FiscalDocument,
  } from "./lib/types";

  // State management
  let products: Product[] = $state([]);
  let loading = $state(true);
  let error = $state(null);
  let cart: CartItem[] = $state([]);
  let paymentMethods: PaymentMethod[] = $state([]);
  let selectedPaymentMethod: PaymentMethod | null = $state(null);
  let currentPayments: Payment[] = $state([]);
  let paymentInputAmount: number = $state(0);
  let customers: Customer[] = $state([]);
  let selectedCustomerId: number | null = $state(null);

  // Derived values
  let cartTotalAmountCents = $derived.by(() => {
    return cart.reduce(
      (total, item) => total + item.product.retail_price_cents * item.quantity,
      0
    );
  });
  let cartTotalAmount = $derived(cartTotalAmountCents / 100);

  let cartAmountDueCents = $derived.by(() => {
    const totalPayments = currentPayments.reduce(
      (total, payment) => total + payment.amountCents,
      0
    );
    return cartTotalAmountCents - totalPayments;
  });
  let cartAmountDue = $derived(cartAmountDueCents / 100);

  // Fetch data
  $effect(() => {
    Promise.all([
      fetch("/products.json"),
      fetch("/payment_methods.json"),
      fetch("/customers.json"),
    ])
      .then(async ([productsRes, paymentMethodsRes, customersRes]) => {
        const productsData = await productsRes.json();
        const paymentMethodsData = await paymentMethodsRes.json();
        const customersData = await customersRes.json();

        products = productsData.map((product: Product) => ({
          ...product,
          retailPriceCents: Number(product.retail_price_cents),
          costPriceCents: Number(product.cost_price_cents),
          retailPrice: Number(product.retail_price_cents) / 100,
          costPrice: Number(product.cost_price_cents) / 100,
        }));

        paymentMethods = paymentMethodsData;
        customers = customersData;
        loading = false;
      })
      .catch((err) => {
        error = err;
        loading = false;
      });
  });

  // Cart functions
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

  // Payment functions
  function addPayment(paymentMethod: PaymentMethod, amount: number) {
    currentPayments = [
      ...currentPayments,
      {
        id: currentPayments.length + 1,
        paymentMethod,
        amountCents: amount,
        amount: amount / 100,
      },
    ];
  }

  function removePayment(payment: Payment) {
    currentPayments = currentPayments.filter((p) => p.id !== payment.id);
  }

  // Sale finalization
  function finalizeSale() {
    const fiscalDocument: FiscalDocument = {
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
          throw new Error("Houve um erro!");
        }
        return response.json();
      })
      .then((data) => {
        cart = [];
        currentPayments = [];
        window.open(`/fiscal_documents/${data.id}`, "_blank");
      })
      .catch((error) => {
        alert(error);
      });
  }
</script>

<Header />

<div class="container-fluid">
  <div class="row">
    <ProductPanel {products} onAddToCart={addToCart} />
    <CartPanel {cart} {cartTotalAmount} onRemoveFromCart={removeFromCart} />
  </div>
</div>

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
        <PaymentPanel
          {paymentMethods}
          {selectedPaymentMethod}
          {paymentInputAmount}
          {cartAmountDue}
          onSelectPaymentMethod={(method) => (selectedPaymentMethod = method)}
          onAddPayment={addPayment}
        />
        <CustomerSelect {customers} bind:selectedCustomerId />
      </div>
      <div class="col-md-6">
        <SaleSummary
          {cartTotalAmount}
          {cartAmountDue}
          {currentPayments}
          onRemovePayment={removePayment}
          onFinalizeSale={finalizeSale}
        />
      </div>
    </div>
  </div>
</div>
