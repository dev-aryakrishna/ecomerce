import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecomerceapp/features/products/data/datasource/product_remote_datasource.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository{

  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<ProductEntity>> getProduct({
    required int limit,
    required int skip
  }) async{
    return await remoteDatasource.getProduct(limit: limit, skip: skip);

  }

  @override
  Future<List<ProductEntity>> searchProducts(String query)
  async{
    return await remoteDatasource.searchProducts(query);
  } 


  @override
  Future<List<String>> getCategories() async{
    return await remoteDatasource.getCategories();
  }


  @override
  Future<List<ProductEntity>> getProductsByCategories(String category)
  async{
    return await remoteDatasource.getProductsByCategories(category);
  }


  @override
  Future<ProductEntity> getProductDetails(int id)
  async{

    return await remoteDatasource.getProductDetails(id);

  }

}