import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../generated/l10n.dart';

class ToastHelper {
  static void _showToast(String msg, BuildContext context) {
    final theme = Theme.of(context);
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: theme.hintColor,
      textColor: theme.cardColor,
    );
  }

  static void sendEmailVerification(String email, BuildContext context) {
    _showToast(S.of(context).email_verification_sent(email), context);
  }

  static void sendPasswordResetEmail(String email, BuildContext context) {
    _showToast(S.of(context).password_reset_sent(email), context);
  }

  static void signInError(BuildContext context) {
    _showToast(S.of(context).sign_in_error, context);
  }

  static void unknownError(BuildContext context) {
    _showToast(S.of(context).unknown_error, context);
  }

  static void networkError(BuildContext context) {
    _showToast(S.of(context).network_error, context);
  }

  static void attemptsError(BuildContext context) {
    _showToast(S.of(context).attempts_ended, context);
  }

  static void interviewFormError(BuildContext context) {
    _showToast(S.of(context).interview_form_error, context);
  }

  static void taskSelectorError(BuildContext context) {
    _showToast(S.of(context).task_selector_error, context);
  }
}
