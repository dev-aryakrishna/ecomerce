import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';

class GetCartItemsUseCase {
  final CartRepository cartRepository;

  GetCartItemsUseCase({required this.cartRepository});

  Future<List<CartItemEntity>> call() async {
    return await cartRepository.getCartItems();
  }
}
