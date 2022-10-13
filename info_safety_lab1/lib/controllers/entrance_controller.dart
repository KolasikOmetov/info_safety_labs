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

  void checkData({
    required BuildContext context,
    required void Function(UserModel user) onSuccess,
    void Function()? onUserNotExists,
    void Function()? onUserBlocked,
    void Function()? onPasswordWrong,
    void Function()? onAccessDenied,
  }) {
    UserModel? user = users.firstWhereOrNull((user) => user.name == userName);
    if (user == null) {
      onUserNotExists?.call();
      return;
    }

    if (user.isBlocked) {
      onUserBlocked?.call();
      return;
    }

    if (user.password.text != password) {
      wrongAttempts++;
      if (wrongAttempts == Constants.maxAttempts) {
        onAccessDenied?.call();
        Future<void>.delayed(const Duration(seconds: 3), () => exitProgram(context));
      } else {
        onPasswordWrong?.call();
      }
      return;
    }

    onSuccess(user);
  }
}
