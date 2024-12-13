// composables/useSales.ts
import { ref, computed } from "vue";
import type {
  Product,
  CartItem,
  Payment,
  PaymentMethod,
  Customer,
  FiscalDocument,
} from "../lib/types";

// Refs para estado
export const products = ref<{ data: Product[]; loading: boolean }>({
  data: [],
  loading: true,
});

export const cart = ref<CartItem[]>([]);

export const paymentMethods = ref<{ data: PaymentMethod[]; loading: boolean }>({
  data: [],
  loading: true,
});

export const selectedPaymentMethod = ref<PaymentMethod | null>(null);

export const currentPayments = ref<Payment[]>([]);

export const paymentInputAmount = ref(0);

export const customers = ref<{ data: Customer[]; loading: boolean }>({
  data: [],
  loading: true,
});

export const selectedCustomerId = ref<number | null>(null);

// Computed values
export const cartTotalAmountCents = computed(() =>
  cart.value.reduce(
    (total, item) => total + item.product.retail_price_cents * item.quantity,
    0
  )
);

export const cartTotalAmount = computed(() => cartTotalAmountCents.value / 100);

export const cartAmountDueCents = computed(() => {
  const totalPayments = currentPayments.value.reduce(
    (total, payment) => total + payment.amountCents,
    0
  );
  return cartTotalAmountCents.value - totalPayments;
});

export const cartAmountDue = computed(() => cartAmountDueCents.value / 100);

// Funções para buscar dados
export const fetchProducts = async () => {
  try {
    const response = await fetch("/products.json");
    const productsData = await response.json();
    products.value.data = productsData.map((product: Product) => ({
      ...product,
      retailPriceCents: Number(product.retail_price_cents),
      costPriceCents: Number(product.cost_price_cents),
      retailPrice: Number(product.retail_price_cents) / 100,
      costPrice: Number(product.cost_price_cents) / 100,
    }));
  } catch (err) {
    console.error("Error fetching products:", err);
  } finally {
    products.value.loading = false;
  }
};

export const fetchPaymentMethods = async () => {
  try {
    const response = await fetch("/payment_methods.json");
    const data = await response.json();
    paymentMethods.value.data = data;
  } catch (err) {
    console.error("Error fetching payment methods:", err);
  } finally {
    paymentMethods.value.loading = false;
  }
};

export const fetchCustomers = async () => {
  try {
    const response = await fetch("/customers.json");
    const data = await response.json();
    customers.value.data = data;
  } catch (err) {
    console.error("Error fetching customers:", err);
  } finally {
    customers.value.loading = false;
  }
};

// Função de inicialização
export const initializeSales = () => {
  fetchProducts();
  fetchPaymentMethods();
  fetchCustomers();
};
