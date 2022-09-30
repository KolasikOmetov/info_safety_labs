// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class EntranceController extends ChangeNotifier {
  static const _maxAttempts = 3;
  String userName = '';
  String password = '';
  final List<UserModel> users = [const AdminModel(name: 'Admin')];

  int wrongAttempts = 0;

  void setUsername(userName) => this.userName = userName;
  void setPassword(password) => this.password = password;

  void checkData({
    required void Function(UserModel user) onSuccess,
    void Function()? onUserNotExists,
    void Function()? onPasswordWrong,
    void Function()? onAccessDenied,
  }) {
    UserModel? user = users.firstWhereOrNull((user) => user.name == userName);
    if (user == null) {
      onUserNotExists?.call();
      return;
    }

    if (user.password.text != password) {
      wrongAttempts++;
      if (wrongAttempts == _maxAttempts) {
        onAccessDenied?.call();
        Future<void>.delayed(const Duration(seconds: 3));
        exitProgram();
      } else {
        onPasswordWrong?.call();
      }
      return;
    }

    onSuccess(user);
  }
}
