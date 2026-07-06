import 'package:ecomerceapp/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_event.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateQuantityUseCase updateQuantityUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.removeFromCartUseCase,
    required this.updateQuantityUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial()) {
    on<LoadCartRequested>(_onLoadCartRequested);
    on<AddToCartRequested>(_onAddToCartRequested);
    on<RemoveFromCartRequested>(_onRemoveFromCartRequested);
    on<UpdateQuantityRequested>(_onUpdateQuantityRequested);
    on<ClearCartRequested>(_onClearCartRequested);
  }


  Future<void> _onLoadCartRequested(
    LoadCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final item = await getCartItemsUseCase();
      if (item.isEmpty) {
        emit(CartEmpty());
      } else {
        final totalPrice = item.fold<double>(
          0,
          (sum , item) => sum + (item.price * item.quantity),
        );
        emit(CartLoaded(item: item, totalPrice: totalPrice));
      }
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }


  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await addToCartUseCase(event.item);
      add(LoadCartRequested());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }


  Future<void> _onRemoveFromCartRequested(
    RemoveFromCartRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await removeFromCartUseCase(event.productId );
      add(LoadCartRequested());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }


  Future<void> _onUpdateQuantityRequested(
    UpdateQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await updateQuantityUseCase(event.productId , event.quantity );
      add(LoadCartRequested());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }


  Future<void> _onClearCartRequested(
    ClearCartRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await clearCartUseCase();
      add(LoadCartRequested());
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }


}
