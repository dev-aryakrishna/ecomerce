import 'package:ecomerceapp/features/settings/presentation/screen/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/features/auth/presentation/screens/splash_screen.dart';
import 'package:ecomerceapp/features/auth/presentation/screens/login_screen.dart';
import 'package:ecomerceapp/features/auth/presentation/screens/signup_screen.dart';
import 'package:ecomerceapp/features/products/presentation/screens/store_listing_screen.dart';
import 'package:ecomerceapp/features/products/presentation/screens/category_listing_screen.dart';
import 'package:ecomerceapp/features/products/presentation/screens/category_product_screen.dart';
import 'package:ecomerceapp/features/products/presentation/screens/product_detail_screen.dart';
import 'package:ecomerceapp/features/home/presentation/screen/main_screen.dart';
import 'package:ecomerceapp/features/cart/presentation/screen/cart_screen.dart';
import 'package:ecomerceapp/features/cart/presentation/screen/checkout_screen.dart';
import 'package:ecomerceapp/features/orders/presentation/screens/orders_screen.dart';
import 'package:ecomerceapp/features/settings/presentation/screen/account_screen.dart';
import 'route_names.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.splash,
  routes: [
    GoRoute(
      path: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: RouteNames.productDetail,
      builder: (context, state) {
        final productId = state.extra as int;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: RouteNames.categoryProducts,
      builder: (context, state) {
        final category = state.extra as String;
        return CategoryProductScreen(category: category);
      },
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: RouteNames.checkout,
      builder: (context, state) => const CheckoutScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainScreen(
        currentLocation: state.matchedLocation,
        child: child,
      ),
      routes: [
        GoRoute(
          path: RouteNames.store,
          builder: (context, state) => const StoreListingScreen(),
        ),
        GoRoute(
          path: RouteNames.categories,
          builder: (context, state) => const CategoryListingScreen(),
        ),
        GoRoute(
          path: RouteNames.cart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: RouteNames.orders,
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: RouteNames.account,
          builder: (context, state) => const AccountScreen(),
        ),
      ],
    ),
  ],
);