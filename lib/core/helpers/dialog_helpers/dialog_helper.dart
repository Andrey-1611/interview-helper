import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_dialog.dart';

class DialogHelper {
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CustomLoadingDialog(text: text),
    );
  }

  static void showCustomDialog({
    required Widget dialog,
    required BuildContext context,
  }) {
    showDialog(context: context, builder: (context) => dialog);
  }
}
