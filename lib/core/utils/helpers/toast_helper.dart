import 'package:fluttertoast/fluttertoast.dart';
import '../../../generated/l10n.dart';

class ToastHelper {
  static final s = S.current;

  static void _showToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static void sendEmailVerification(String email) {
    _showToast(s.email_verification_sent(email));
  }

  static void sendPasswordResetEmail(String email) {
    _showToast(s.password_reset_sent(email));
  }

  static void signInError() {
    _showToast(s.sign_in_error);
  }

  static void unknownError() {
    _showToast(s.unknown_error);
  }

  static void networkError() {
    _showToast(s.network_error);
  }

  static void attemptsError() {
    _showToast(s.attempts_ended);
  }

  static void interviewFormError() {
    _showToast(s.interview_form_error);
  }

  static void taskSelectorError() {
    _showToast(s.task_selector_error);
  }
}
