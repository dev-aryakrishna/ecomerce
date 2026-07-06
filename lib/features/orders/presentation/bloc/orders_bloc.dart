import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:ecomerceapp/features/orders/domain/usecases/get_orders_usecase.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final CreateOrderUsecase createOrderUsecase;
  final GetOrdersUsecase getOrdersUsecase;

  OrdersBloc({
    required this.createOrderUsecase,
    required this.getOrdersUsecase,
  }) : super(OrdersInitial()) {
    on<LoadOrdersRequested>(_onLoadOrders);
    on<CreateOrderRequested>(_onCreateOrder);
  }

  Future<void> _onLoadOrders(
    LoadOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    try {
      final orders = await getOrdersUsecase();
      if (orders.isEmpty) {
        emit(OrdersEmpty());
      } else {
        emit(OrdersLoaded(orders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  Future<void> _onCreateOrder(
    CreateOrderRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await createOrderUsecase(event.order);
      emit(OrderCreated(event.order));
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }
}