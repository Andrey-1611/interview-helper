import 'package:fluttertoast/fluttertoast.dart';
import 'package:interview_master/core/theme/app_pallete.dart';

class ToastHelper {
  static void _showToast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: AppPalette.cardBackground,
      textColor: AppPalette.textPrimary,
    );
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

  static void attemptsError() {
    _showToast(msg: 'Попытки закончились, возвращайтесь завтра');
  }

  static void interviewFormError() {
    _showToast(msg: 'Выберите направление и сложность');
  }
}
