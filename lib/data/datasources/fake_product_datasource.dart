import '../models/product_model.dart';

/// FakeProductDataSource - Nguồn dữ liệu giả lập
///
/// Trong thực tế, đây sẽ là API call hoặc đọc từ database
/// Sử dụng fake data để demo mà không cần backend
class FakeProductDataSource {
  /// Danh sách sản phẩm giả lập
  static List<ProductModel> getProducts() {
    return [
      const ProductModel(
        id: 'p001',
        name: 'iPhone 15 Pro Max',
        description: 'Điện thoại Apple iPhone 15 Pro Max 256GB',
        price: 29990000,
        imageUrl: 'assets/images/iphone-15-pro-max.png',
        category: 'Điện thoại',
      ),
      const ProductModel(
        id: 'p002',
        name: 'Samsung Galaxy S24 Ultra',
        description: 'Điện thoại Samsung Galaxy S24 Ultra 512GB',
        price: 31990000,
        imageUrl: 'assets/images/samsung-galaxy-s24-ultra.png',
        category: 'Điện thoại',
      ),
      const ProductModel(
        id: 'p003',
        name: 'MacBook Pro M3',
        description: 'Laptop Apple MacBook Pro 14 inch M3 Pro',
        price: 49990000,
        imageUrl: 'assets/images/Macbook-pro.png',
        category: 'Laptop',
      ),
      const ProductModel(
        id: 'p004',
        name: 'iPad Pro M2',
        description: 'Máy tính bảng Apple iPad Pro 12.9 inch M2',
        price: 28990000,
        imageUrl: 'assets/images/ipad-pro-m2.png',
        category: 'Tablet',
      ),
      const ProductModel(
        id: 'p005',
        name: 'AirPods Pro 2',
        description: 'Tai nghe Apple AirPods Pro thế hệ 2',
        price: 5990000,
        imageUrl: 'assets/images/airpods-pro-2.png',
        category: 'Phụ kiện',
      ),
      const ProductModel(
        id: 'p006',
        name: 'Apple Watch Ultra 2',
        description: 'Đồng hồ thông minh Apple Watch Ultra 2',
        price: 21990000,
        imageUrl: 'assets/images/apple-watch.png',
        category: 'Đồng hồ',
      ),
      const ProductModel(
        id: 'p007',
        name: 'Sony WH-1000XM5',
        description: 'Tai nghe chống ồn Sony WH-1000XM5',
        price: 7990000,
        imageUrl: 'assets/images/Tai-nghe-chong-on.png',
        category: 'Phụ kiện',
      ),
      const ProductModel(
        id: 'p008',
        name: 'Dell XPS 15',
        description: 'Laptop Dell XPS 15 Core i7 Gen 13',
        price: 42990000,
        imageUrl: 'assets/images/Laptop-Dell-XPS.png',
        category: 'Laptop',
      ),
    ];
  }
}
