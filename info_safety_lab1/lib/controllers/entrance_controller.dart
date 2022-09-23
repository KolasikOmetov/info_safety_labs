import 'package:flutter/material.dart';

class EntranceController extends ChangeNotifier {
  String userName = '';
  String password = '';

  void setUsername(userName) => this.userName = userName;
  void setPassword(password) => this.password = password;

  void checkData() {
    // TODO
  }
}
