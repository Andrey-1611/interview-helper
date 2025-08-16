import 'package:flutter/material.dart';
import 'package:interview_master/app/widgets/custom_loading_dialog.dart';
import 'package:interview_master/features/interview/presentation/widgets/custom_directions_dialog.dart';

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

  static void showDirectionsDialog(BuildContext context, List<String> directions) {
    showDialog(context: context, builder: (context) {
      return CustomDirectionsDialog(directions: directions,);
    });
  }
}
