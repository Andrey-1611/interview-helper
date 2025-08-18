import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_dialog.dart';

class DialogHelper {

  static void showLoadingDialog(BuildContext context, String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomLoadingDialog(text: text,);
      },
    );
  }
}
