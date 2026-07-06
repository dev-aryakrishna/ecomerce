import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProduct({
    required int limit,
    required int skip
  });

Future<List<ProductEntity>> searchProducts(String query);

Future<List<String>> getCategories();

Future<List<ProductEntity>> getProductsByCategories(String category);

Future<ProductEntity> getProductDetails(int id);

}





