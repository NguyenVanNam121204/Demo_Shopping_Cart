import '../constants/app_constants.dart';

// DART MIXIN - ValidationMixin
//
// Mixin chứa các logic validate dữ liệu
// Có thể được sử dụng bởi nhiều class khác nhau
//
// Ví dụ sử dụng:
// class CartProvider with ValidationMixin {
//   void addItem() {
//     if (isValidQuantity(quantity)) { ... }
//   }
// }
mixin ValidationMixin {
  // Kiểm tra số lượng có hợp lệ không
  bool isValidQuantity(int quantity) {
    return quantity >= AppConstants.minQuantityPerItem &&
        quantity <= AppConstants.maxQuantityPerItem;
  }

  // Kiểm tra giá có hợp lệ không
  bool isValidPrice(double price) {
    return price > 0;
  }

  // Kiểm tra tên sản phẩm có hợp lệ không
  bool isValidProductName(String name) {
    return name.isNotEmpty && name.length >= 2;
  }

  // Lấy thông báo lỗi cho số lượng không hợp lệ
  String getQuantityErrorMessage(int quantity) {
    if (quantity < AppConstants.minQuantityPerItem) {
      return 'Số lượng tối thiểu là ${AppConstants.minQuantityPerItem}';
    }
    if (quantity > AppConstants.maxQuantityPerItem) {
      return 'Số lượng tối đa là ${AppConstants.maxQuantityPerItem}';
    }
    return '';
  }
}
