import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.productName,
    required super.price,
    required super.quantity, 
    required super.productImage,
    super.originalPrice,
  }) ;

  factory CartItemModel.fromJson(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as int,
      productName: map['productName'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      productImage: map['productImage'] as String,
      originalPrice: (map['originalPrice'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'productImage' : productImage,
      'originalPrice': originalPrice,
    };
  }
}
