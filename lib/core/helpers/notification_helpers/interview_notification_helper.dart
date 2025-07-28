import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../global_services/notifications/models/notification.dart';

class InterviewNotificationHelper {
  void showInterviewsErrorNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка загрузки данных, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  void checkInterviewsErrorNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка оценки результатов, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  static SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}
