import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:ecomerceapp/core/network/dio_client.dart';
import 'package:ecomerceapp/core/themes/theme_service.dart';
import 'package:ecomerceapp/core/localization/localization_service.dart';
import 'package:ecomerceapp/core/utils/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:ecomerceapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ecomerceapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ecomerceapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/login_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/signup_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ecomerceapp/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/signup/signup_bloc.dart';

import 'package:ecomerceapp/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ecomerceapp/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ecomerceapp/features/profile/domain/repositories/profile_repository.dart';
import 'package:ecomerceapp/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:ecomerceapp/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:ecomerceapp/features/profile/presentation/bloc/profile_bloc.dart';


import 'package:ecomerceapp/features/products/data/datasource/product_remote_datasource.dart';
import 'package:ecomerceapp/features/products/data/repositories/product_repository_impl.dart';
import 'package:ecomerceapp/features/products/domain/repositories/product_repository.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_product_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/search_product_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_products_by_categories_usecase.dart';
import 'package:ecomerceapp/features/products/domain/usecases/get_product_detail_usecase.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/products/products_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/categories/categories_bloc.dart';
import 'package:ecomerceapp/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';

import 'package:ecomerceapp/features/cart/data/datasource/cart_local_data_source.dart';
import 'package:ecomerceapp/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:ecomerceapp/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:ecomerceapp/features/cart/domain/usecases/update_quantity_usecase.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';

import 'package:ecomerceapp/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:ecomerceapp/features/orders/data/repositories/order_repository_impl.dart';
import 'package:ecomerceapp/features/orders/domain/repositories/order_repository.dart';
import 'package:ecomerceapp/features/orders/domain/usecases/create_order_usecase.dart';
import 'package:ecomerceapp/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:ecomerceapp/features/orders/presentation/bloc/orders_bloc.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecomerceapp/core/connectivity/connectivity_cubit.dart';
import 'package:ecomerceapp/core/services/connectivity_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseClient>()),
  );

  //Authentication
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  //Authusecases
  sl.registerLazySingleton(() => LoginUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => IsLoggedInUsecase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(sl<AuthRepository>()));


  //Authblocs
  sl.registerFactory<LoginBloc>(
    () => LoginBloc(loginUseCase: sl<LoginUsecase>()),
  );
  sl.registerFactory<SignupBloc>(
    () => SignupBloc(signUpUseCase: sl<SignupUsecase>()),
  );
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      logoutUseCase: sl<LogoutUsecase>(),
      isLoggedInUseCase: sl<IsLoggedInUsecase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUsecase>(),
    ),
  );

  //Profile (kept separate from AuthRepository/AuthBloc on purpose:
  //authentication and profile management are different concerns)
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl<SupabaseClient>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetProfileUsecase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl<ProfileRepository>()));

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUsecase: sl<GetProfileUsecase>(),
      updateProfileUsecase: sl<UpdateProfileUsecase>(),
    ),
  );

  //Dio
  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);

  //products
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(sl<Dio>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductRemoteDatasource>()),
  );

  //productsusecases
  sl.registerLazySingleton(() => GetProductUsecase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => SearchProductUsecase(sl<ProductRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(sl<ProductRepository>()));
  sl.registerLazySingleton(
    () => GetProductsByCategoriesUsecase(sl<ProductRepository>()),
  );
  sl.registerLazySingleton(
    () => GetProductDetailUsecase(sl<ProductRepository>()),
  );

  
  //productsblocs
  sl.registerFactory<ProductsBloc>(
    () => ProductsBloc(
      getProductsUsecase: sl<GetProductUsecase>(),
      searchProductsUsecase: sl<SearchProductUsecase>(),
      getProductByCategoryUsecase: sl<GetProductsByCategoriesUsecase>(),
    ),
  );
  sl.registerFactory<CategoriesBloc>(
    () => CategoriesBloc(getCategoriesUsecase: sl<GetCategoriesUsecase>()),
  );
  sl.registerFactory<ProductDetailBloc>(
    () => ProductDetailBloc(
      getProductDetailUsecase: sl<GetProductDetailUsecase>(),
    ),
  );

  // Cart datasource & repository
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(cartLocalDataSource: sl<CartLocalDataSource>()),
  );

  // Cart usecases
  sl.registerLazySingleton(() => GetCartItemsUseCase(cartRepository: sl<CartRepository>()));
  sl.registerLazySingleton(() => AddToCartUseCase(cartRepository: sl<CartRepository>()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(cartRepository: sl<CartRepository>()));
  sl.registerLazySingleton(() => UpdateQuantityUseCase(cartRepository: sl<CartRepository>()));
  sl.registerLazySingleton(() => ClearCartUseCase(cartRepository: sl<CartRepository>()));

  // Cart bloc
  sl.registerFactory<CartBloc>(() => CartBloc(
    getCartItemsUseCase: sl<GetCartItemsUseCase>(),
    addToCartUseCase: sl<AddToCartUseCase>(),
    removeFromCartUseCase: sl<RemoveFromCartUseCase>(),
    updateQuantityUseCase: sl<UpdateQuantityUseCase>(),
    clearCartUseCase: sl<ClearCartUseCase>(),
  ));
  

  //notification , localization & theme services
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<LocalizationService>(
    () => LocalizationService(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ThemeService>(
    () => ThemeService(sl<SharedPreferences>()),
  );

  // Orders
  sl.registerLazySingleton<OrdersLocalDataSource>(
    () => OrdersLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<OrdersLocalDataSource>()),
  );
  sl.registerLazySingleton(() => CreateOrderUsecase(sl<OrderRepository>()));
  sl.registerLazySingleton(() => GetOrdersUsecase(sl<OrderRepository>()));
  sl.registerFactory<OrdersBloc>(
    () => OrdersBloc(
      createOrderUsecase: sl<CreateOrderUsecase>(),
      getOrdersUsecase: sl<GetOrdersUsecase>(),
    ),
  );

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(sl<Connectivity>()),
  );
  sl.registerFactory<ConnectivityCubit>(
    () => ConnectivityCubit(connectivityService: sl<ConnectivityService>()),
  );
}
