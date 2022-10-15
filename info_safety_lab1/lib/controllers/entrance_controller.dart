// ignore: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:info_safety_lab1/constants.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class EntranceController extends ChangeNotifier {
  EntranceController(this._userListController);

  final UserListController _userListController;
  String userName = '';
  String password = '';
  List<UserModel> get users => _userListController.users;

  int wrongAttempts = 0;

  void setUsername(userName) => this.userName = userName;
  void setPassword(password) => this.password = password;

  /// Проверка введенных данных пользователем
  void checkData({
    required BuildContext context,
    required void Function(UserModel user) onSuccess,
    void Function()? onUserNotExists,
    void Function()? onUserBlocked,
    void Function()? onPasswordWrong,
    void Function()? onAccessDenied,
  }) {
    UserModel? user = users.firstWhereOrNull((user) => user.name == userName);

    /// Проверка существования пользователя
    if (user == null) {
      onUserNotExists?.call();
      return;
    }

    /// Проверка блокировки пользователя
    if (user.isBlocked) {
      onUserBlocked?.call();
      return;
    }

    final passwordHash = hashPassword(password);

    /// Проверка пароля
    if (user.password.hash != passwordHash) {
      wrongAttempts++;
      if (wrongAttempts == Constants.maxAttempts) {
        onAccessDenied?.call();
        Future<void>.delayed(const Duration(seconds: 3), () => exitProgram(context));
      } else {
        onPasswordWrong?.call();
      }
      return;
    }

    /// Проверка успешно пройдена
    onSuccess(user);
  }
}
