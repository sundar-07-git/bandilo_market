import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../../products/models/product.dart';

class CartNotifier extends StateNotifier<Map<String, CartItem>> {
  CartNotifier() : super({});

  void addToCart(Product product, int quantity) {
    if (quantity <= 0) return;
    if (state.containsKey(product.id)) {
      state = {
        ...state,
        product.id: state[product.id]!.copyWith(
          quantity: state[product.id]!.quantity + quantity,
        ),
      };
    } else {
      state = {
        ...state,
        product.id: CartItem(product: product, quantity: quantity),
      };
    }
  }

  void updateQuantity(String productId, int delta) {
    if (!state.containsKey(productId)) return;
    final currentItem = state[productId]!;
    final newQty = currentItem.quantity + delta;

    if (newQty <= 0) {
      final newState = Map<String, CartItem>.from(state);
      newState.remove(productId);
      state = newState;
    } else {
      state = {
        ...state,
        productId: currentItem.copyWith(quantity: newQty),
      };
    }
  }

  void clearCart() => state = {};
}

final cartProvider = StateNotifierProvider<CartNotifier, Map<String, CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.values.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
});