import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    await _plugin.initialize(const InitializationSettings(android: androidSettings, iOS: iosSettings));
  }

  Future<void> showRideCompleteNotification(String message) async {
    const androidDetails = AndroidNotificationDetails('ride_channel', 'Ride', importance: Importance.high);
    const iosDetails = DarwinNotificationDetails();
    await _plugin.show(0, 'Поездка завершена', message, const NotificationDetails(android: androidDetails, iOS: iosDetails));
  }
}