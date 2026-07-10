import 'package:ecomerceapp/core/localization/localization_service.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecomerceapp/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/core/themes/theme_service.dart';
import 'package:ecomerceapp/core/utils/notification_service.dart';
import 'package:ecomerceapp/router/route_names.dart';
import 'package:ecomerceapp/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go(RouteNames.login);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Theme Section
            Text(
              l10n.theme,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: sl<ThemeService>(),
              builder: (context, _) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.themeLight),
                      value: ThemeMode.light,
                      groupValue: sl<ThemeService>().currentThemeMode,
                      onChanged: (_) =>
                          sl<ThemeService>().setThemeMode(ThemeMode.light),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.themeDark),
                      value: ThemeMode.dark,
                      groupValue: sl<ThemeService>().currentThemeMode,
                      onChanged: (_) =>
                          sl<ThemeService>().setThemeMode(ThemeMode.dark),
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text(l10n.themeSystem),
                      value: ThemeMode.system,
                      groupValue: sl<ThemeService>().currentThemeMode,
                      onChanged: (_) =>
                          sl<ThemeService>().setThemeMode(ThemeMode.system),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),

            // Language Section
            Text(
              l10n.language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: sl<LocalizationService>(),
              builder: (context, _) {
                return Column(
                  children: [
                    RadioListTile<Locale>(
                      title: const Text('English'),
                      value: const Locale('en'),
                      groupValue: sl<LocalizationService>().currentLocale,
                      onChanged: (_) => sl<LocalizationService>()
                          .setLocale(const Locale('en')),
                    ),
                    RadioListTile<Locale>(
                      title: const Text('Español'),
                      value: const Locale('es'),
                      groupValue: sl<LocalizationService>().currentLocale,
                      onChanged: (_) => sl<LocalizationService>()
                          .setLocale(const Locale('es')),
                    ),
                  ],
                );
              },
            ),
            const Divider(height: 32),

            // Notifications Section
            Text(
              l10n.notifications,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListenableBuilder(
              listenable: sl<NotificationService>(),
              builder: (context, _) {
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.orderNotifications),
                  subtitle: Text(l10n.orderNotificationsDesc),
                  value: sl<NotificationService>().notificationsEnabled,
                  onChanged: (value) =>
                      sl<NotificationService>().setNotificationsEnabled(value),
                );
              },
            ),
            const Divider(height: 32),

            // App Version
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(l10n.version),
              trailing: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text('...');
                  return Text(snapshot.data!.version);
                },
              ),
            ),
            const Divider(),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                l10n.logout,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () =>
                  context.read<AuthBloc>().add(LogoutRequested()),
            ),
          ],
        ),
      ),
    );
  }
}