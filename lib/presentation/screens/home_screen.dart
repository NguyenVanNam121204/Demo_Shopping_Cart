import 'package:flutter/material.dart';
import '../widgets/cart_icon_widget.dart';
import 'product_list_screen.dart';
import 'cart_screen.dart';

// HomeScreen - Màn hình chính của ứng dụng
//
// Sử dụng BottomNavigationBar để chuyển đổi giữa các tab
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const ProductListScreen(), const CartScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🛍️ Shopping Cart Demo'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // CartIconWidget sử dụng CONSUMER
          // Tự động cập nhật khi giỏ hàng thay đổi
          CartIconWidget(
            onTap: () {
              setState(() {
                _currentIndex = 1; // Chuyển sang tab giỏ hàng
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Sản phẩm',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Giỏ hàng',
          ),
        ],
      ),
    );
  }
}
