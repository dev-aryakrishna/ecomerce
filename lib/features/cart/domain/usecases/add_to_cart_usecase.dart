import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';

class  AddToCartUseCase {
  final CartRepository cartRepository;

   AddToCartUseCase({required this.cartRepository});

  Future<void> call(CartItemEntity item) async {
    return await cartRepository.addToCart(item);
  }
}
