// ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:info_safety_lab1/constants.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class ChangePasswordController extends ChangeNotifier {
  ChangePasswordController(this._userController, this._userListController);

  final UserController _userController;
  final UserListController _userListController;
  UserModel get _user => _userController.user;
  String oldPassword = '';
  String newPassword = '';

  int wrongAttempts = 0;

  void setOldPassword(oldPassword) => this.oldPassword = oldPassword;
  void setNewPassword(newPassword) => this.newPassword = newPassword;

  void checkData({
    required BuildContext context,
    required void Function() onSuccess,
    void Function()? onPasswordsEquals,
    void Function()? onPasswordsLimits,
    void Function()? onPasswordWrong,
    void Function()? onAccessDenied,
  }) {
    final oldPasswordHash = hashPassword(oldPassword);
    if (_user.password.hash != oldPasswordHash) {
      wrongAttempts += 1;
      if (wrongAttempts == Constants.maxAttempts) {
        onAccessDenied?.call();
        Future<void>.delayed(const Duration(seconds: 3), () => exitProgram(context));
      } else {
        onPasswordWrong?.call();
      }
      return;
    }

    if (oldPassword == newPassword) {
      onPasswordsEquals?.call();
      return;
    }

    if (_user.isPasswordChoosingLimited && _userController.isNotValidPasswordLimit(newPassword)) {
      onPasswordsLimits?.call();
      return;
    }

    _userListController.setPassword(_user, hashPassword(newPassword));
    onSuccess();
  }
}
