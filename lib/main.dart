import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'app.dart';

void main() {
  runApp(
    // ChangeNotifierProvider: Cung cấp CartProvider cho toàn bộ Widget tree
    // Đặt ở tầng cao nhất để tất cả Widget con đều có thể truy cập
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}
