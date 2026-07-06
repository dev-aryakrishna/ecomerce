import 'package:dio/dio.dart';
import 'package:ecomerceapp/core/constants/api_constants.dart';
import 'package:ecomerceapp/features/products/data/models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProduct({
    required int limit,
    required int skip
  });

  Future<List<ProductModel>> searchProducts(String query);

  Future<List<String>> getCategories();

  Future<List<ProductModel>> getProductsByCategories(String category);

  Future<ProductModel> getProductDetails(int id);

}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource{

  final Dio dio;
  ProductRemoteDatasourceImpl(this.dio);


  @override
  Future<List<ProductModel>> getProduct({
    required int limit,
    required int skip
  })async{
    final response = await dio.get(
      ApiConstants.products , 
      queryParameters: {
        'limit':limit , 
        'skip':skip
      }
    );
    final List <dynamic> data = response.data['products'];
    return data.map((e)=>ProductModel.fromJson(e)).toList();
  }


  @override
  Future<List<ProductModel>> searchProducts(String query)
  async{
    final response = await dio.get(
      ApiConstants.searchproducts , 
      queryParameters: {
        'q':query
      }
    );
    final List <dynamic> data = response.data['products'];
    return data.map((e)=>ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<String>> getCategories()
  async{
    final response = await dio.get(
      ApiConstants.categories , 
    );
    final List <dynamic> data = response.data;
    return data.map((e)=>e['slug'].toString()).toList();
  }

  @override
  Future<List<ProductModel>> getProductsByCategories( String category)
  async{
    final response = await dio.get(
      ApiConstants.productByCategory(category), 
    );
    final List <dynamic> data = response.data['products'];
    return data.map((e)=>ProductModel.fromJson(e)).toList();
  }


   @override
  Future<ProductModel> getProductDetails(  int id)
  async{
    final response = await dio.get(
      ApiConstants.productById( id), 
    );
    return ProductModel.fromJson(response.data);
  }

}