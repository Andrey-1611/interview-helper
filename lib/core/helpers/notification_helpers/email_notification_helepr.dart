import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../global_services/notifications/models/notification.dart';

class EmailNotificationHelper {
  static void sendEmailVerificationNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо с подтверждением отправлено на вашу почту!',
        Icon(Icons.info),
      ),
    );
  }

  static void sendNewEmailVerificationNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо с подтверждением отправлено на вашу новую почту!',
        Icon(Icons.info),
      ),
    );
  }

  static void emailNotVerifiedNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Пожалуйста, подтвердите свою почту!',
        Icon(Icons.error),
      ),
    );
  }

  static void emailVerificationErrorNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка проверки почты, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  static void checkEmailErrorNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка проверки почты, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  static void changeEmailErrorNotification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка изменения почты, проверьте введенные данные!',
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
