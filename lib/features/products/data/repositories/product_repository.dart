import '../product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ProductRemoteDataSource _dataSource;

  const ProductRepository(this._dataSource);

  Future<List<ProductModel>> getProducts() {
    return _dataSource.getProducts();
  }

  Future<List<String>> getCategories() {
    return _dataSource.getCategories();
  }

  Future<List<ProductModel>> getProductsByCategory(String name) {
    return _dataSource.getProductsByCategory(name);
  }

  Future<ProductModel> getProductById(int id) {
    return _dataSource.getProductById(id);
  }

  Future<void> addToCart(int productId) {
    return _dataSource.addToCart(productId);
  }
}
