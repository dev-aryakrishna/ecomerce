import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';

class GetProductUsecase {

  final ProductRepository repository;

  GetProductUsecase(this.repository);

  Future<List<ProductEntity>> call({
    required int limit,
    required int skip,
  })
  {
  return repository.getProduct(limit: limit, skip: skip);
  }

}