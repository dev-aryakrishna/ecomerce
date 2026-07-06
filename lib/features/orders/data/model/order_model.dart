import 'dart:convert';
import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.orderId,
    required super.products,
    required super.totalAmount,
    required super.orderDate,
    required super.orderStatus,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['order_id'] as String,
      products: List<Map<String, dynamic>>.from(
        jsonDecode(map['products'] as String),
      ),
      totalAmount: map['total_amount'] as double,
      orderDate: map['order_date'] as String,
      orderStatus: map['order_status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'products': jsonEncode(products),
      'total_amount': totalAmount,
      'order_date': orderDate,
      'order_status': orderStatus,
    };
  }
}