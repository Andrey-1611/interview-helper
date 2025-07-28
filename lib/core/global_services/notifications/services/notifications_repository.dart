import '../models/notification.dart';

abstract interface class NotificationsRepository {
  void sendNotification(MyNotification notification);
}
