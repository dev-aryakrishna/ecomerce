import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> createOrder(OrderEntity order);
  Future<List<OrderEntity>> getOrders();
}