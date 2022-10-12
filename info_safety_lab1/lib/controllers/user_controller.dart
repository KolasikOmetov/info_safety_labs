import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';

class UserController extends ChangeNotifier {
  UserController(this._userListController, this.userName);

  final UserListController _userListController;
  final String userName;
  UserModel get user => _userListController.users.firstWhere((user) => user.name == userName);

  bool isNotValidPasswordLimit(String password) => !(RegExp(r'[0-9]').hasMatch(password) &&
      RegExp(r'[.,!?:;]').hasMatch(password) &&
      RegExp(r'[+\-*\/^]').hasMatch(password));
}
