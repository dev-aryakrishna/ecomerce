import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/core/constants/app_constants.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_product_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/search_product_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_products_by_categories_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductUsecase getProductsUsecase;
  final SearchProductUsecase searchProductsUsecase;
  final GetProductsByCategoriesUsecase getProductByCategoryUsecase;

  int _skip = 0;

  ProductsBloc({
    required this.getProductsUsecase,
    required this.searchProductsUsecase,
    required this.getProductByCategoryUsecase,
  }) : super(ProductsInitial()) {
    on<FetchProductsRequested>(_onFetchProducts);
    on<LoadMoreProductsRequested>(_onLoadMore);
    on<RefreshProductsRequested>(_onRefresh);
    on<SearchProductsRequested>(_onSearch);
    on<FetchProductsByCategoryRequested>(_onFetchByCategory);
  }

  Future<void> _onFetchProducts(
    FetchProductsRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      _skip = 0;
      final products = await getProductsUsecase(
        limit: AppConstants.pageLimit,
        skip: _skip,
      );
      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(
          products: products,
          hasReachedMax: products.length < AppConstants.pageLimit,
        ));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProductsRequested event,
    Emitter<ProductsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductsLoaded && !currentState.hasReachedMax) {
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        _skip += AppConstants.pageLimit;
        final newProducts = await getProductsUsecase(
          limit: AppConstants.pageLimit,
          skip: _skip,
        );
        emit(currentState.copyWith(
          products: [...currentState.products, ...newProducts],
          hasReachedMax: newProducts.length < AppConstants.pageLimit,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onRefresh(
    RefreshProductsRequested event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      _skip = 0;
      final products = await getProductsUsecase(
        limit: AppConstants.pageLimit,
        skip: _skip,
      );
      emit(ProductsLoaded(
        products: products,
        hasReachedMax: products.length < AppConstants.pageLimit,
      ));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onSearch(
    SearchProductsRequested event,
    Emitter<ProductsState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(FetchProductsRequested());
      return;
    }
    emit(ProductsLoading());
    try {
      final products = await searchProductsUsecase(event.query);
      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products: products, hasReachedMax: true));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onFetchByCategory(
    FetchProductsByCategoryRequested event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await getProductByCategoryUsecase(event.category);
      if (products.isEmpty) {
        emit(ProductsEmpty());
      } else {
        emit(ProductsLoaded(products: products, hasReachedMax: true));
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }
}