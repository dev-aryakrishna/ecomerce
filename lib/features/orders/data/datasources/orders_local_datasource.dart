import 'package:sqflite/sqflite.dart';
import 'package:ecomerceapp/core/constants/app_constants.dart';
import 'package:ecomerceapp/features/orders/data/model/order_model.dart';
import 'package:ecomerceapp/core/database/database_helper.dart';


abstract class OrdersLocalDataSource {
  Future<void> createOrder(OrderModel order);
  Future<List<OrderModel>> getOrders();
}

class OrdersLocalDataSourceImpl implements OrdersLocalDataSource {
  Future<Database> get database => DatabaseHelper.database;

  @override
  Future<void> createOrder(OrderModel order) async {
    final db = await database;
    await db.insert(
      AppConstants.ordersTable,
      order.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final db = await database;
    final maps = await db.query(
      AppConstants.ordersTable,
      orderBy: 'order_date DESC',
    );
    return maps.map((e) => OrderModel.fromMap(e)).toList();
  }
}