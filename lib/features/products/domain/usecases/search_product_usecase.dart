import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';

class SearchProductUsecase {

  final ProductRepository repository;

  SearchProductUsecase(this.repository);

  Future<List<ProductEntity>> call(String query)
  {
    return repository.searchProducts(query);
  }

}