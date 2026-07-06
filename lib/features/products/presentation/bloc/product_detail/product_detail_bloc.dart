import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_product_detail_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetailUsecase getProductDetailUsecase;

  ProductDetailBloc({required this.getProductDetailUsecase})
      : super(ProductDetailInitial()) {
    on<FetchProductDetailRequested>(_onFetchDetail);
  }

  Future<void> _onFetchDetail(
    FetchProductDetailRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());
    try {
      final product = await getProductDetailUsecase(event.productId);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}