import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecomerceapp/features/orders/domain/repositories/order_repository.dart';

class CreateOrderUsecase {
  final OrderRepository repository;

  CreateOrderUsecase(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.createOrder(order);
  }
}