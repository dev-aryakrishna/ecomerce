import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ecomerceapp/core/connectivity/connectivity_cubit.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/core/localization/localization_service.dart';
import 'package:ecomerceapp/core/themes/app_theme.dart';
import 'package:ecomerceapp/core/themes/theme_service.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomerceapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:ecomerceapp/router/app_router.dart';
import 'package:ecomerceapp/core/widgets/connectivity_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<ConnectivityCubit>()),
        BlocProvider(create: (_) => sl<CartBloc>()),
      ],
      child: ListenableBuilder(
        listenable: Listenable.merge([
          sl<LocalizationService>(),
          sl<ThemeService>(),
        ]),
        builder: (context, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'ShopEase',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: sl<ThemeService>().currentThemeMode,
            routerConfig: appRouter,
            locale: sl<LocalizationService>().currentLocale,
            supportedLocales: LocalizationService.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return ConnectivityWrapper(
             child: child ?? const SizedBox(),
            );
           },
          );
        },
      ),
    );
  }
}