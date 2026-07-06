import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecomerceapp/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecomerceapp/features/cart/data/models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {

  final CartLocalDataSource cartLocalDataSource;

  CartRepositoryImpl({required this.cartLocalDataSource});



  @override
  Future<List<CartItemEntity>> getCartItems()async{
    return await cartLocalDataSource.getCartItems();
  }


  @override
  Future<void> addToCart(CartItemEntity item) async {
    await cartLocalDataSource.addToCart(
      CartItemModel(
        price: item.price,
        productId: item.productId,
        productName: item.productName,
        quantity: item.quantity,
        productImage: item.productImage,
        originalPrice: item.originalPrice,
      ),
    );
  }


  @override
  Future<void> removeFromCart(int productId) async {
    await cartLocalDataSource.removeFromCart(productId);
  }


  @override
  Future<void> updateQuantity(int productId , int quantity) async {
    await cartLocalDataSource.updateQuantity(productId , quantity);
  }


  @override
  Future<void> clearCart() async {
    await cartLocalDataSource.clearCart();
  }
  

}
