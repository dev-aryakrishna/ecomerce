import 'package:equatable/equatable.dart';
import 'package:ecomerceapp/features/products/domain/entities/product_entity.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ProductsLoaded copyWith({
    List<ProductEntity>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [products, hasReachedMax, isLoadingMore];
}

class ProductsEmpty extends ProductsState {}

class ProductsError extends ProductsState {
  final String message;
  const ProductsError(this.message);
  @override
  List<Object?> get props => [message];
}