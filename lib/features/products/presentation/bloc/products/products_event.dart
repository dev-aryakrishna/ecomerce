import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
  @override
  List<Object?> get props => [];
}

class FetchProductsRequested extends ProductsEvent {}

class LoadMoreProductsRequested extends ProductsEvent {}

class RefreshProductsRequested extends ProductsEvent {}

class SearchProductsRequested extends ProductsEvent {
  final String query;
  const SearchProductsRequested(this.query);
  @override
  List<Object?> get props => [query];
}

class FetchProductsByCategoryRequested extends ProductsEvent {
  final String category;
  const FetchProductsByCategoryRequested(this.category);
  @override
  List<Object?> get props => [category];
}