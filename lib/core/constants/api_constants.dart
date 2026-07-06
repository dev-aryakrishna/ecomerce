
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';

  //products
  static const String products = '/products';
  static const String searchproducts = '/products/search';
  static const String categories = '/products/categories';

  //dynamic
 static String productById(int id) => '/products/$id';
 static String productByCategory(String category) => '/products/category/$category';
}