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
      orderId: map['order_id'] as String ? ?? '',
      products: _parseProducts(map['products']),
      totalAmount: (map['total_amount']as num?)?.toDouble() ?? 0.0,
      orderDate: map['order_date'] as String ? ?? '',
      orderStatus: map['order_status'] as String ? ?? 'unknown',
    );
  }

   static List<Map<String, dynamic>> _parseProducts(Object? raw){
    if(raw is! String || raw.isEmpty) return const[];
    try{
      final decoded = jsonDecode(raw);
      if(decoded is! List) return const[];
      return List <Map<String , dynamic>>.from(decoded);
    }
    catch(_){
      return const[];
    }

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