import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/services/system_service.dart';

class UserListController extends ChangeNotifier {
  UserListController(this.systemService) {
    users = systemService.loadUsers();
  }

  final SystemService systemService;

  late List<UserModel> users;

  void setUserLimit(UserModel user, bool isPasswordChoosingLimited) {
    checkUserExists(
        user, (int index) => users[index] = user.copyWith(isPasswordChoosingLimited: isPasswordChoosingLimited));
    _applyChanges();
  }

  void setUserBlock(UserModel user, bool isBlocked) {
    checkUserExists(user, (int index) => users[index] = user.copyWith(isBlocked: isBlocked));
    _applyChanges();
  }

  void checkUserExists(UserModel user, void Function(int index) callback) {
    final int index = users.indexOf(user);
    if (index != -1) {
      callback(index);
    }
  }

  bool isUserExists(String username) {
    return users.firstWhereOrNull((element) => element.name == username) != null;
  }

  void addNewUserByName(String newUserName) {
    final newUser = UserModel(name: newUserName);
    users.add(newUser);
    _applyChanges();
  }

  void setPassword(UserModel user, String password) {
    func(int index) {
      var copyWith = user.password.copyWith(text: password);
      var copyWith2 = user.copyWith(password: copyWith);
      users[index] = copyWith2;
    }

    checkUserExists(user, func);
    _applyChanges();
  }

  void _applyChanges() {
    systemService.saveUsers(users);
    notifyListeners();
  }
}
