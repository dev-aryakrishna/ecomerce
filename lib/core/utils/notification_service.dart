import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecomerceapp/core/constants/storage_key.dart';

/// Handles local notifications and the user's notification preference.
/// The preference is persisted via [SharedPreferences] under
/// [StorageKey.notificationsEnabled] and defaults to enabled.
class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final SharedPreferences _prefs;

  NotificationService(this._prefs);

  bool get notificationsEnabled =>
      _prefs.getBool(StorageKey.notificationsEnabled) ?? true;

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(StorageKey.notificationsEnabled, enabled);
    notifyListeners();
  }

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(initSettings);

    // On Android 13+ (API 33) notifications also require a runtime
    // permission grant, separate from the manifest declaration.
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showOrderSuccessNotification({
    required String orderId,
    required double totalAmount,
  }) async {
    // Respect the user's notification preference from Settings.
    if (!notificationsEnabled) return;

    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Notifications for order updates',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      0,
      'Order Placed Successfully! 🎉',
      'Your order placed for the product  #$orderId — Total: \$${totalAmount.toStringAsFixed(2)} . Expect updates on your order status soon  ',
      notificationDetails,
    );
  }
}