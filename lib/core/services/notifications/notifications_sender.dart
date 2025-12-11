import 'package:dreamscape/core/services/notifications/i_notifications_sender.dart';
import 'package:dreamscape/core/util/logger/logger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final class NotificationsSender with LoggerMixin
    implements INotificationsSender  {
  NotificationsSender({
    required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  }) : _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  @override
  Future<void> showNotification(int id, String name, String description) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'alarms', //TODO swap to test channels
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        id,
        name,
        description,
        details,
      );
       logger.debug('notications shown');
    } on Object catch (e) {
      logger.debug(e.toString());
    }
  }
}
