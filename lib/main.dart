import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecomerceapp/core/constants/env_constants.dart';
import 'package:ecomerceapp/dependency_injection/injection.dart';
import 'package:ecomerceapp/core/utils/notification_service.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: EnvConstants.supabaseUrl,
    anonKey: EnvConstants.supabaseAnonKey,
  );

  await configureDependencies();

  await sl<NotificationService>().init();

  runApp(const App());
}
