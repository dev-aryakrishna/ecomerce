import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_categories_usecase.dart';
import 'categories_event.dart';
import 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent , CategoriesState>{

  final GetCategoriesUsecase getCategoriesUsecase;

  CategoriesBloc({required this.getCategoriesUsecase}):super(CategoriesInitial()){
    on<FetchCategoriesRequested>(_onFetchCategories);
  }
  Future<void>_onFetchCategories(
    FetchCategoriesRequested event ,
    Emitter<CategoriesState> emit,
    )async{
        emit(CategoriesLoading());
        try{
          final categories = await getCategoriesUsecase();
          emit(CategoriesLoaded(categories));
        }
        catch(e){
          emit(CategoriesError(e.toString()));
        }
    }
}