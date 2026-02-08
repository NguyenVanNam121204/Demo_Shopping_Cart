# 🛒 Flutter Shopping Cart Demo

> Demo ứng dụng giỏ hàng sử dụng **Provider** và **ChangeNotifier** để quản lý State trong Flutter.

---

## 📋 Mục Đích

Dự án này được xây dựng để **demo và học tập** các khái niệm:

- **Provider Pattern** - Quản lý state toàn cục
- **ChangeNotifier** - Class cơ sở để notify listeners khi state thay đổi
- **Consumer** - Widget rebuild toàn bộ khi `notifyListeners()` được gọi
- **Selector** - Widget chỉ rebuild khi giá trị được chọn thay đổi (tối ưu performance)
- **Dart Mixins** - Tái sử dụng code với `PriceFormatterMixin` và `ValidationMixin`
- **SharedPreferences** - Lưu trữ dữ liệu persistent (giỏ hàng không mất khi reload)

---

## 🏗️ Kiến Trúc Dự Án

```
lib/
├── main.dart                    # Entry point, khởi tạo ChangeNotifierProvider
├── app.dart                     # MaterialApp configuration
├── core/
│   ├── constants/
│   │   └── app_constants.dart   # Hằng số ứng dụng
│   └── mixins/
│       ├── price_formatter_mixin.dart  # Format giá tiền (VNĐ)
│       └── validation_mixin.dart       # Validate số lượng
├── data/
│   ├── datasources/
│   │   └── fake_product_datasource.dart  # Dữ liệu sản phẩm fake
│   ├── models/
│   │   └── product_model.dart   # Model sản phẩm (với toJson/fromJson)
│   └── repositories/
│       └── product_repository.dart
├── domain/
│   └── entities/
│       └── cart_item.dart       # Entity giỏ hàng (với toJson/fromJson)
└── presentation/
    ├── providers/
    │   └── cart_provider.dart   # ⭐ ChangeNotifier quản lý giỏ hàng
    ├── screens/
    │   ├── home_screen.dart     # Màn hình chính
    │   └── cart_screen.dart     # Màn hình giỏ hàng
    └── widgets/
        ├── cart_icon_widget.dart   # 🔴 Sử dụng Consumer
        ├── cart_total_widget.dart  # 🟢 Sử dụng Selector
        ├── product_card_widget.dart
        └── cart_item_widget.dart
```

---

## ⚡ Consumer vs Selector

### Consumer
```dart
Consumer<CartProvider>(
  builder: (context, cart, child) {
    // Rebuild MỖI KHI notifyListeners() được gọi
    return Badge(count: cart.totalQuantity);
  },
)
```

### Selector
```dart
Selector<CartProvider, double>(
  selector: (context, cart) => cart.totalPrice,
  builder: (context, totalPrice, child) {
    // CHỈ rebuild khi totalPrice thay đổi
    return Text('Total: $totalPrice');
  },
)
```

### So Sánh

| Tiêu chí | Consumer | Selector |
|----------|----------|----------|
| Khi nào rebuild? | Mỗi khi `notifyListeners()` | Chỉ khi giá trị selected thay đổi |
| Performance | Thấp hơn | Cao hơn |
| Use case | Cần toàn bộ state | Chỉ cần một phần state |

---

## 🚀 Cách Chạy

```bash
# Clone repository
git clone <your-repo-url>

# Di chuyển vào thư mục
cd Demo_Shopping_Cart

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run -d chrome    # Web
flutter run -d windows   # Windows
flutter run              # Device mặc định
```

---

## 📦 Dependencies

| Package | Mục đích |
|---------|----------|
| `provider` | State management |
| `shared_preferences` | Lưu trữ local storage |
| `google_fonts` | Font hỗ trợ tiếng Việt |

---

## 🎯 Tính Năng Demo

- ✅ Thêm/Xóa sản phẩm vào giỏ hàng
- ✅ Tăng/Giảm số lượng sản phẩm
- ✅ Hiển thị tổng số lượng (Consumer)
- ✅ Hiển thị tổng tiền (Selector)
- ✅ Lưu giỏ hàng vào SharedPreferences (không mất khi reload)
- ✅ Demo sự khác biệt rebuild giữa Consumer và Selector

---

## 📚 Tài Liệu Tham Khảo

| Ref | Tên Tài Liệu | Nguồn |
|-----|--------------|-------|
| [1] | Simple app state management (Sử dụng Provider) | https://docs.flutter.dev/data-and-backend/state-mgmt/simple |
| [2] | Provider Package Documentation | https://pub.dev/packages/provider |
| [3] | SharedPreferences Package | https://pub.dev/packages/shared_preferences |
| [4] | Flutter State Management Overview | https://docs.flutter.dev/data-and-backend/state-mgmt/options |

---

## 👨‍💻 Tác Giả

Nhóm 5 - Demo project để học tập Flutter State Management với Provider.

---

## 📄 License

MIT License - Sử dụng tự do cho mục đích học tập.
