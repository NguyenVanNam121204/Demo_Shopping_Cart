import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'app.dart';

void main() {
  // Đảm bảo Flutter binding được khởi tạo trước khi dùng SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    // ChangeNotifierProvider: Cung cấp CartProvider cho toàn bộ Widget tree
    // Đặt ở tầng cao nhất để tất cả Widget con đều có thể truy cập
    ChangeNotifierProvider(
      create: (context) {
        // Tạo CartProvider và load dữ liệu từ SharedPreferences
        final cartProvider = CartProvider();
        cartProvider.loadCart(); // Load giỏ hàng đã lưu trước đó
        return cartProvider;
      },
      child: const MyApp(),
    ),
  );
}
