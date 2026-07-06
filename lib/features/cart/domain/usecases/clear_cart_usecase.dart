import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';

class ClearCartUseCase {
  final CartRepository cartRepository;

  ClearCartUseCase({required this.cartRepository});

  Future<void> call() async {
    return await cartRepository.clearCart();
  }
}
