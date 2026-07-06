import 'package:equatable/equatable.dart';
import 'package:ecomerceapp/features/cart/domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable{

  const CartEvent();

  @override
  List<Object?> get props => [];

}


class LoadCartRequested extends CartEvent{}


class AddToCartRequested extends CartEvent{

  final CartItemEntity item;

  const AddToCartRequested(this.item);

  @override
  List<Object?> get props => [item];
}


class RemoveFromCartRequested extends CartEvent{

  final int productId;

  const RemoveFromCartRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}


class UpdateQuantityRequested extends CartEvent{

  final int  productId ; 
  final int  quantity;

  const UpdateQuantityRequested(this.productId, this.quantity);

  @override
  List<Object?> get props => [productId , quantity];
}

class ClearCartRequested extends CartEvent{}