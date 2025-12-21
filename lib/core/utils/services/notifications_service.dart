import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsService(this._notificationsPlugin);

  NotificationDetails get _notificationDetails {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        importance: Importance.max,
        priority: Priority.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> setupDailyNotification(bool isRussian) async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    if (pending.any((n) => n.id == 1)) return;
    await _notificationsPlugin.periodicallyShow(
      1,
      isRussian ? 'Готов к собеседованию?' : 'Ready for the interview?',
      isRussian
          ? 'Новый вопрос уже ждёт!'
          : 'A new question is already waiting for you',
      RepeatInterval.daily,
      _notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> disableDailyNotification() async {
    await _notificationsPlugin.cancel(1);
  }
}
