import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';

class UpdateQuantityUseCase {
  final CartRepository cartRepository;

  UpdateQuantityUseCase({required this.cartRepository});

  Future<void> call(int productId , int quantity) async {
    return await cartRepository.updateQuantity(productId , quantity);
  }
}
