import type { Product } from "./types";
import { cart } from "./saleStore";

export function addToCart(product: Product) {
  const existingItem = cart.value.find(
    (item) => item.product.id === product.id
  );
  if (existingItem) {
    existingItem.quantity += 1;
  } else {
    cart.value.push({ product, quantity: 1 });
  }
}
