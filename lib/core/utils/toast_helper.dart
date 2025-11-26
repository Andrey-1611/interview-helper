import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    _showToast('Письмо с подтвержением отправлено на $email', context);
  }

  static void sendPasswordResetEmail(String email, BuildContext context) {
    _showToast('Письмо со сбросом пароля отправлено на $email', context);
  }

  static void signInError(BuildContext context) {
    _showToast('Ошибка входа, проверьте введенные данные', context);
  }

  static void unknownError(BuildContext context) {
    _showToast('Неизвестная ошибка, попробуйте позже', context);
  }

  static void networkError(BuildContext context) {
    _showToast('Нет подключения к интернету', context);
  }

  static void attemptsError(BuildContext context) {
    _showToast('Попытки закончились, возвращайтесь завтра', context);
  }

  static void interviewFormError(BuildContext context) {
    _showToast('Выберите направление и сложность', context);
  }

  static void taskSelectorError(BuildContext context) {
    _showToast('Заполните все необходимые поля', context);
  }
}
