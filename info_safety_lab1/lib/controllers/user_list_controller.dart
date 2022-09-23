import 'package:flutter/material.dart';
import 'package:info_safety_lab1/model/user_model.dart';

class UserListController extends ChangeNotifier {
  final List<UserModel> users = [];

  void setUserLimit(UserModel user, bool isPasswordChoosingLimited) {
    checkUserExists(
        user, (int index) => users[index] = user.copyWith(isPasswordChoosingLimited: isPasswordChoosingLimited));
    notifyListeners();
  }

  void setUserBlock(UserModel user, bool isBlocked) {
    checkUserExists(user, (int index) => users[index] = user.copyWith(isBlocked: isBlocked));
    notifyListeners();
  }

  void checkUserExists(UserModel user, void Function(int index) callback) {
    final int index = users.indexOf(user);
    if (index != -1) {
      callback(index);
    }
  }
}
