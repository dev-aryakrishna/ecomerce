import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
  @override
  List<Object?> get props => [];
}

class FetchProductDetailRequested extends ProductDetailEvent {
  final int productId;
  const FetchProductDetailRequested(this.productId);
  @override
  List<Object?> get props => [productId];
}
