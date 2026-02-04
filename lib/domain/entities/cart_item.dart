import '../../data/models/product_model.dart';

/// CartItem - Entity đại diện cho một item trong giỏ hàng
///
/// Entity thuộc Domain Layer trong Clean Architecture
/// Chứa business logic liên quan đến item trong giỏ
class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  /// Tính tổng tiền của item này
  double get totalPrice => product.price * quantity;

  /// Tăng số lượng
  void increment() {
    quantity++;
  }

  /// Giảm số lượng
  void decrement() {
    if (quantity > 1) {
      quantity--;
    }
  }

  /// Copy với số lượng mới
  CartItem copyWith({int? quantity}) {
    return CartItem(product: product, quantity: quantity ?? this.quantity);
  }
}
