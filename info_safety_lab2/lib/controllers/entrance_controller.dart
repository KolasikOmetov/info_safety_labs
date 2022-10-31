import 'package:flutter/material.dart';

class EntranceController extends ChangeNotifier {
  EntranceController();

  String password = '';

  void setPassword(password) => this.password = password;

  /// Проверка введенных данных пользователем
  void checkData({
    required BuildContext context,
    required void Function() onSuccess,
  }) {
    onSuccess();
  }
}
