import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../global_services/notifications/models/notification.dart';

class EmailNotificationHelper {
  void sendPasswordResetEmail(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо со сбросом пароля отправлено на вашу почту!',
        Icon(Icons.info),
      ),
    );
  }

  void sendEmailVerification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо с подтверждением отправлено на вашу почту!',
        Icon(Icons.info),
      ),
    );
  }

  void sendNewEmailVerification(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Письмо с подтверждением отправлено на вашу новую почту!',
        Icon(Icons.info),
      ),
    );
  }

  void emailNotVerified(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Пожалуйста, подтвердите свою почту!',
        Icon(Icons.error),
      ),
    );
  }

  void sendPasswordResetEmailError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка отправки письма со сбросом пароля, попробуйте позже!!',
        Icon(Icons.info),
      ),
    );
  }

  void emailVerificationError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка проверки почты, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  void checkEmailError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка проверки почты, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  void changeEmailError(BuildContext context) {
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
