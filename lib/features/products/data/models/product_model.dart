import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {

  const ProductModel({
  
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.discountPercentage,
    required super.rating,
    required super.stock,
    required super.category,
    required super.thumbnail,
    required super.images
  });

  factory ProductModel.fromJson(Map<String , dynamic>json){
    return ProductModel(
    id: json['id'] as int, 
    title: json['title'] as String? ?? '', 
    description: json['description'] as String? ?? '', 
    price: (json['price']as num?)?.toDouble()?? 0.0, 
    discountPercentage:  (json['discountPercentage']as num?)?.toDouble()?? 0.0, 
    rating: (json['rating']as num?)?.toDouble()?? 0.0, 
    stock: json['stock'] as int? ?? 0, 
    category: json['category'] as String? ?? '',  
    thumbnail: json['thumbnail'] as String? ?? '', 
    images: (json['images'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .where((e) => e.isNotEmpty)
            .toList() ??
        const []
    );
  }


}