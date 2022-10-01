// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:info_safety_lab1/constants.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class ChangePasswordController extends ChangeNotifier {
  ChangePasswordController(this._userController);

  final UserController _userController;
  UserModel get _user => _userController.user;
  String oldPassword = '';
  String newPassword = '';

  int wrongAttempts = 0;

  void setUsername(oldPassword) => this.oldPassword = oldPassword;
  void setPassword(newPassword) => this.newPassword = newPassword;

  void checkData({
    required void Function() onSuccess,
    void Function()? onPasswordsEquals,
    void Function()? onPasswordsLimits,
    void Function()? onPasswordWrong,
    void Function()? onAccessDenied,
  }) {
    if (_user.password.text != oldPassword) {
      wrongAttempts += 1;
      if (wrongAttempts == Constants.maxAttempts) {
        onAccessDenied?.call();
        Future<void>.delayed(const Duration(seconds: 3), () => exitProgram());
      } else {
        onPasswordWrong?.call();
      }
      return;
    }

    if (oldPassword == newPassword) {
      onPasswordsEquals?.call();
      return;
    }

    if (_user.isPasswordChoosingLimited) {
      // TODO
      onPasswordsLimits?.call();
      return;
    }

    onSuccess();
  }
}
