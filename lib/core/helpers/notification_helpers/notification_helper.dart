import 'package:interview_master/core/helpers/notification_helpers/auth_notification_helper.dart';
import 'package:interview_master/core/helpers/notification_helpers/email_notification_helepr.dart';
import 'package:interview_master/core/helpers/notification_helpers/interview_notification_helper.dart';

class NotificationHelper {
  static final AuthNotificationHelper auth = AuthNotificationHelper();
  static final EmailNotificationHelper email = EmailNotificationHelper();
  static final InterviewNotificationHelper interview = InterviewNotificationHelper();
}
