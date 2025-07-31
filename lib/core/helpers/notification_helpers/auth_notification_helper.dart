import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../global_services/notifications/blocs/send_notification_bloc/send_notification_bloc.dart';
import '../../global_services/notifications/models/notification.dart';

class AuthNotificationHelper {
  void greeting(BuildContext context, String name) {
    context.read<SendNotificationBloc>().add(
      _sendNotification('$name, добро пожаловать!', Icon(Icons.star)),
    );
  }

  void signOut(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification('Вы успешно вышли из аккаунта!', Icon(Icons.star)),
    );
  }

  void checkUserError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка проверки пользователя, попробуйте позже!',
        Icon(Icons.error),
      ),
    );
  }

  void signInError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка входа, проверьте введенные данные!',
        Icon(Icons.error),
      ),
    );
  }

  void signUpError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification(
        'Ошибка регистрации, проверьте введенные данные!',
        Icon(Icons.error),
      ),
    );
  }

  void signOutError(BuildContext context) {
    context.read<SendNotificationBloc>().add(
      _sendNotification('Ошибка выхода, попробуйте позже!', Icon(Icons.error)),
    );
  }

  static SendNotification _sendNotification(String text, Icon icon) {
    return SendNotification(
      notification: MyNotification(text: text, icon: icon),
    );
  }
}
