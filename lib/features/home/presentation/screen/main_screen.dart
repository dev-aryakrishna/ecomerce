import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/core/themes/app_colors.dart';
import 'package:ecomerceapp/router/route_names.dart';


class MainScreen extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const MainScreen({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  static const _routes = [
    RouteNames.store,
    RouteNames.categories,
    RouteNames.cart,
    RouteNames.orders,
    RouteNames.account,
  ];

  int get _currentIndex {
    final index = _routes.indexWhere(
      (route) => currentLocation.startsWith(route),
    );
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentIndex = _currentIndex;
    final isHome = currentIndex == 0;

    return PopScope(
      canPop: isHome,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go(RouteNames.store);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(top: BorderSide(color: context.colors.divider)),
          ),
          child: SafeArea(
            child:SizedBox(height: 75,
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                if (index == currentIndex) return;
                context.go(_routes[index]);
              },
              
              backgroundColor: Colors.transparent,
              elevation: 0,
              
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_rounded),
                  label: l10n.store,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.grid_view_outlined),
                  activeIcon: const Icon(Icons.grid_view_rounded),
                  label: l10n.categories,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  activeIcon: const Icon(Icons.shopping_cart_rounded),
                  label: l10n.cart,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long_outlined),
                  activeIcon: const Icon(Icons.receipt_long_rounded),
                  label: l10n.orders,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline_rounded),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: l10n.account,
                ),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
