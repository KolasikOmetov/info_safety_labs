import 'package:flutter/material.dart';
import 'package:info_safety_lab1/model/user_model.dart';

class UserController extends ChangeNotifier {
  UserController(this.user);

  final UserModel user;

  bool isNotValidPasswordLimit(String password) => !(RegExp(r'[0-9]').hasMatch(password) &&
      RegExp(r'[.,!?:;]').hasMatch(password) &&
      RegExp(r'[+\-*\/^]').hasMatch(password));
}
