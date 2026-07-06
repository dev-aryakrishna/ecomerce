import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecomerceapp/features/orders/domain/repositories/order_repository.dart';

class GetOrdersUsecase {
  final OrderRepository repository;

  GetOrdersUsecase(this.repository);

  Future<List<OrderEntity>> call() {
    return repository.getOrders();
  }
}