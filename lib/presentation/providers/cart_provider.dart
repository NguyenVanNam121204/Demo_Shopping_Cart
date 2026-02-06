import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/mixins/price_formatter_mixin.dart';
import '../../core/mixins/validation_mixin.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

// CartProvider - ChangeNotifier quản lý state giỏ hàng

// 1. CHANGENOTIFIER:
//    - Kế thừa từ ChangeNotifier để có khả năng notify listeners
//    - Chứa state (_items) và các method thay đổi state
//
// 2. DART MIXINS:
//    - Sử dụng 'with' để thêm PriceFormatterMixin và ValidationMixin
//    - Cho phép tái sử dụng code format giá và validate
//
// 3. NOTIFYLISTENERS():
//    - Gọi sau mỗi lần thay đổi state
//    - Thông báo cho tất cả Widget đang lắng nghe để rebuild
//
// 4. SHAREDPREFERENCES:
//    - Lưu trữ giỏ hàng dưới dạng JSON
//    - Khi reload trang/app, dữ liệu được khôi phục từ storage
class CartProvider extends ChangeNotifier
    with PriceFormatterMixin, ValidationMixin {
  // Key để lưu vào SharedPreferences
  static const String _cartKey = 'cart_items';

  // ============================================
  // STATE - Dữ liệu được quản lý
  // ============================================

  // Danh sách các item trong giỏ hàng (private)
  final List<CartItem> _items = [];

  // Trạng thái đã load dữ liệu từ storage chưa
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Danh sách ID sản phẩm đang được chọn (để demo Selector vs Consumer)
  // Khi thay đổi selectedProductIds:
  // - Consumer SẼ rebuild (vì notifyListeners() được gọi)
  // - Selector KHÔNG rebuild (vì totalPrice không đổi)
  final Set<String> _selectedProductIds = {};

  // ============================================
  // GETTERS - Đọc state (không thay đổi state)
  // ============================================

  // Lấy danh sách items (unmodifiable để tránh thay đổi trực tiếp)
  List<CartItem> get items => List.unmodifiable(_items);

  // Lấy danh sách ID sản phẩm đang được chọn
  Set<String> get selectedProductIds => Set.unmodifiable(_selectedProductIds);

  // Kiểm tra sản phẩm có đang được chọn không
  bool isProductSelected(String productId) =>
      _selectedProductIds.contains(productId);

  // Tổng số lượng sản phẩm trong giỏ
  // Consumer sẽ lắng nghe giá trị này
  int get totalQuantity {
    if (_items.isEmpty) return 0;
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tổng tiền của giỏ hàng
  // Selector sẽ lắng nghe giá trị này
  double get totalPrice {
    if (_items.isEmpty) return 0;
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  // Tổng tiền đã format (sử dụng PriceFormatterMixin)
  String get totalPriceFormatted => formatPrice(totalPrice);

  // Kiểm tra giỏ hàng có trống không
  bool get isEmpty => _items.isEmpty;

  // Số loại sản phẩm khác nhau trong giỏ
  int get itemCount => _items.length;

  // ============================================
  // METHODS - Thay đổi state
  // ============================================

  // Chọn/bỏ chọn sản phẩm (DEMO: Consumer rebuild, Selector không rebuild)
  // Vì totalPrice không thay đổi khi chọn sản phẩm
  void toggleSelectProduct(String productId) {
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
    } else {
      _selectedProductIds.add(productId);
    }

    debugPrint('🎯 Selected products: $_selectedProductIds');
    debugPrint('   → totalPrice vẫn là: $totalPrice (không đổi)');
    debugPrint('   → Consumer SẼ rebuild, Selector KHÔNG rebuild');

    // notifyListeners() được gọi nhưng totalPrice không đổi
    // → Consumer rebuild, Selector KHÔNG rebuild
    notifyListeners();
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(ProductModel product) {
    // Kiểm tra sản phẩm đã có trong giỏ chưa
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Sản phẩm đã có -> tăng số lượng
      final currentQuantity = _items[existingIndex].quantity;

      // Sử dụng ValidationMixin để kiểm tra
      if (isValidQuantity(currentQuantity + 1)) {
        _items[existingIndex].increment();
      }
    } else {
      // Sản phẩm chưa có -> thêm mới
      _items.add(CartItem(product: product));
    }

    // Gọi _notifyAndSave() để thông báo thay đổi VÀ lưu vào storage
    // Tất cả Consumer và Selector đang lắng nghe sẽ được rebuild
    _notifyAndSave();

    debugPrint('Added: ${product.name} | Total items: $totalQuantity');
  }

  // Xóa sản phẩm khỏi giỏ hàng
  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);

    // Thông báo thay đổi và lưu vào storage
    _notifyAndSave();

    debugPrint('Removed product: $productId | Total items: $totalQuantity');
  }

  // Tăng số lượng sản phẩm
  void incrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      final currentQuantity = _items[index].quantity;

      // Sử dụng ValidationMixin
      if (isValidQuantity(currentQuantity + 1)) {
        _items[index].increment();
        _notifyAndSave();

        debugPrint(
          'Incremented: ${_items[index].product.name} -> ${_items[index].quantity}',
        );
      }
    }
  }

  // Giảm số lượng sản phẩm
  void decrementQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].decrement();
        _notifyAndSave();

        debugPrint(
          'Decremented: ${_items[index].product.name} -> ${_items[index].quantity}',
        );
      } else {
        // Số lượng = 1, xóa luôn
        removeFromCart(productId);
      }
    }
  }

  // Cập nhật số lượng cụ thể
  void updateQuantity(String productId, int newQuantity) {
    // Sử dụng ValidationMixin để validate
    if (!isValidQuantity(newQuantity)) {
      debugPrint('Invalid quantity: $newQuantity');
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == productId);

    if (index != -1) {
      _items[index].quantity = newQuantity;
      _notifyAndSave();

      debugPrint(
        'Updated quantity: ${_items[index].product.name} -> $newQuantity',
      );
    }
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    _items.clear();
    _notifyAndSave();

    debugPrint('Cart cleared');
  }

  // Kiểm tra sản phẩm có trong giỏ không
  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  // Lấy số lượng của một sản phẩm trong giỏ
  int getQuantity(String productId) {
    final item = _items
        .where((item) => item.product.id == productId)
        .firstOrNull;
    return item?.quantity ?? 0;
  }

  // ============================================
  // SHAREDPREFERENCES - Lưu trữ persistent
  // ============================================

  // Load giỏ hàng từ SharedPreferences khi khởi động app
  // Gọi method này trong main() hoặc sau khi Provider được tạo
  Future<void> loadCart() async {
    if (_isInitialized) return; // Đã load rồi, không load lại

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);

      if (cartJson != null && cartJson.isNotEmpty) {
        // Decode JSON string thành List
        final List<dynamic> decoded = jsonDecode(cartJson);

        // Chuyển đổi từng item từ JSON thành CartItem
        _items.clear();
        for (final itemJson in decoded) {
          _items.add(CartItem.fromJson(itemJson as Map<String, dynamic>));
        }

        debugPrint('✅ Loaded ${_items.length} items from storage');
      } else {
        debugPrint('📭 No saved cart found');
      }
    } catch (e) {
      debugPrint('❌ Error loading cart: $e');
    }

    _isInitialized = true;
    notifyListeners();
  }

  // Lưu giỏ hàng vào SharedPreferences
  // Gọi tự động sau mỗi lần thay đổi giỏ hàng
  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Chuyển đổi List<CartItem> thành JSON string
      final List<Map<String, dynamic>> itemsJson = _items
          .map((item) => item.toJson())
          .toList();
      final cartJson = jsonEncode(itemsJson);

      await prefs.setString(_cartKey, cartJson);

      debugPrint('💾 Saved ${_items.length} items to storage');
    } catch (e) {
      debugPrint('❌ Error saving cart: $e');
    }
  }

  // Helper method: notify + save
  // Sử dụng thay cho notifyListeners() đơn thuần
  void _notifyAndSave() {
    notifyListeners();
    _saveCart(); // Lưu vào storage mỗi khi có thay đổi
  }
}
