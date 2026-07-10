import 'package:ecomerceapp/core/utils/price_calculation.dart';


class CartItemEntity {

  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final String productImage;
  /// Pre-discount ("was") price, if the product had one when it was added
  /// to the cart. Null when the product wasn't on sale.
  final double? originalPrice;


  const CartItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.productImage,
    this.originalPrice,
  });

  double get totalPrice => price * quantity;

  /// Amount saved on this line item vs. its original price, or 0 if it
  /// wasn't discounted.
  double get savings =>PriceCalculation.savingsFor(
    price: price, 
    originalPrice: originalPrice, 
    quantity: quantity
  );

  double get discountPercentage =>  PriceCalculation.discountPercentageForm(
    price: price, 
    originalPrice: originalPrice
  ).toDouble();

}