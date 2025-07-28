import 'dart:developer';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:interview_master/app/navigation/app_router.dart';
import 'package:interview_master/core/global_services/notifications/models/notification.dart';
import 'notifications_repository.dart';

class NotificationsService implements NotificationsRepository {
  @override
  void sendNotification(MyNotification notification) {
    final navigatorKey = AppRouter.navigatorKey;

    try {
      DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        builder: (context) {
          return ToastCard(
            leading: notification.icon,
            title: Text(notification.text),
          );
        },
      ).show(navigatorKey.currentContext!);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
