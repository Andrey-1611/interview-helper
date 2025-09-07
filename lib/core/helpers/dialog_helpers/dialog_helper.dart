import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_dialog.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_sign_out_dialog.dart';

class DialogHelper {
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomLoadingDialog(text: text),
    );
  }

  static void showSignOutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => CustomSignOutDialog());
  }

  static void showCustomDialog(BuildContext context, Widget dialog) {
    showDialog(context: context, builder: (context) => dialog);
  }
}
