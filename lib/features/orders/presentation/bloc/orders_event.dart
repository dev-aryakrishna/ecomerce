import 'package:equatable/equatable.dart';
import 'package:ecomerceapp/features/orders/domain/entities/order_entity.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrdersRequested extends OrdersEvent {}

class CreateOrderRequested extends OrdersEvent {
  final OrderEntity order;
  const CreateOrderRequested(this.order);
  @override
  List<Object?> get props => [order];
}