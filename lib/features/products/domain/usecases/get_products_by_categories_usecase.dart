import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';

class GetProductsByCategoriesUsecase {

  final ProductRepository repository;

  GetProductsByCategoriesUsecase(this.repository);

  Future<List<ProductEntity>> call(String category){
    return repository.getProductsByCategories(category);
  }

}