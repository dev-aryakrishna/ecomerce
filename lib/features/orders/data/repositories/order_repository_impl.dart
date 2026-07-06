import 'package:ecomerceapp/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:ecomerceapp/features/orders/data/model/order_model.dart';
import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecomerceapp/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrdersLocalDataSource localDataSource;

  OrderRepositoryImpl(this.localDataSource);

  @override
  Future<void> createOrder(OrderEntity order) async {
    await localDataSource.createOrder(
      OrderModel(
        orderId: order.orderId,
        products: order.products,
        totalAmount: order.totalAmount,
        orderDate: order.orderDate,
        orderStatus: order.orderStatus,
      ),
    );
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    return await localDataSource.getOrders();
  }
}