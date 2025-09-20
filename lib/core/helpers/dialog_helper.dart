import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_indicator.dart';

class DialogHelper {
  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [const CustomLoadingIndicator(), Text(text)],
          ),
        );
      },
    );
  }

  static void showCustomDialog({
    required Widget dialog,
    required BuildContext context,
  }) {
    showDialog(context: context, builder: (context) => dialog);
  }
}
