import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:interview_master/app/navigation/app_router.dart';

class ToastHelper {
  /*
    static void _showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
      webBgColor: "white",
      webPosition: "center",
      timeInSecForIosWeb: 4,
    );
  }
  */

  static void _showToast({required String msg}) {
    DelightToastBar(
      autoDismiss: true,
      position: DelightSnackbarPosition.top,
      builder: (context) {
        return ToastCard(title: Text(msg));
      },
    ).show(AppRouter.navigatorKey.currentContext!);
  }

  static void sendEmailVerification(String email) {
    _showToast(msg: 'Письмо с подтвержением отправлено на ${email.trim()}');
  }

  static void sendAgainEmailVerification() {
    _showToast(msg: 'Письмо с подтвержением отправлено на вашу почту');
  }

  static void sendPasswordResetEmail(String email) {
    _showToast(msg: 'Письмо со сбросом пароля отправлено на ${email.trim()}');
  }

  static void signInError() {
    _showToast(msg: 'Ошибка входа, проверьте введенные данные');
  }

  static void loadingError() {
    _showToast(msg: 'Ошибка загрузки данных, попробуйте позже');
  }

  static void unknownError() {
    _showToast(msg: 'Неизвестная ошибка, попробуйте позже');
  }

  static void networkError() {
    _showToast(msg: 'Нет подключения к интернету');
  }

  static void custom(String msg) {
    _showToast(msg: msg);
  }
}
