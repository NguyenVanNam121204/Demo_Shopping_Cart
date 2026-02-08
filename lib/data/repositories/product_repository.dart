import '../datasources/fake_product_datasource.dart';
import '../models/product_model.dart';

// ProductRepository - Repository Pattern
//
// Repository đóng vai trò trung gian giữa Data Source và Domain Layer
// Giúp tách biệt logic lấy dữ liệu với business logic
class ProductRepository {
  // Lấy tất cả sản phẩm
  List<ProductModel> getAllProducts() {
    return FakeProductDataSource.getProducts();
  }
}
