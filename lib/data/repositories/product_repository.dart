import '../datasources/fake_product_datasource.dart';
import '../models/product_model.dart';

/// ProductRepository - Repository Pattern
///
/// Repository đóng vai trò trung gian giữa Data Source và Domain Layer
/// Giúp tách biệt logic lấy dữ liệu với business logic
class ProductRepository {
  /// Lấy tất cả sản phẩm
  List<ProductModel> getAllProducts() {
    return FakeProductDataSource.getProducts();
  }

  /// Lấy sản phẩm theo ID
  ProductModel? getProductById(String id) {
    final products = FakeProductDataSource.getProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Lấy sản phẩm theo danh mục
  List<ProductModel> getProductsByCategory(String category) {
    final products = FakeProductDataSource.getProducts();
    return products.where((p) => p.category == category).toList();
  }

  /// Lấy danh sách các danh mục
  List<String> getCategories() {
    final products = FakeProductDataSource.getProducts();
    return products.map((p) => p.category).toSet().toList();
  }
}
