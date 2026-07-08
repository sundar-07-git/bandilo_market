import '../../products/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;

  CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}