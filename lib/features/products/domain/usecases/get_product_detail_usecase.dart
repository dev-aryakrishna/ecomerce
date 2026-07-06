import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';

class GetProductDetailUsecase {

  final ProductRepository repository;

  GetProductDetailUsecase(this.repository);

  Future<ProductEntity> call(int id){

    return repository.getProductDetails(id);
  }

}

