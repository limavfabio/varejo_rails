export type Product = {
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

export type CartItem = {
  product: Product;
  quantity: number;
};

export type PaymentMethod = {
  id: number;
  name: string;
};

export type Payment = {
  id: number;
  paymentMethod: PaymentMethod;
  amountCents: number;
  amount: number;
};

export type Customer = {
  id: number;
  name: string;
  address: string;
  createdAt: string;
  updatedAt: string;
};

export type FiscalDocument = {
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
