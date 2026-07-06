import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  final CartRepository cartRepository;

  RemoveFromCartUseCase({required this.cartRepository});

  Future<void> call(int productId) async {
    return await cartRepository.removeFromCart(productId);
  }
}
