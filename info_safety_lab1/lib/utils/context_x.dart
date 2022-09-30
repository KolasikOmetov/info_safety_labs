import 'package:flutter/widgets.dart';
import 'package:info_safety_lab1/controllers/entrance_controller.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:provider/provider.dart';

extension ContextX on BuildContext {
  UserListController get userListController => read<UserListController>();
  EntranceController get entranceController => read<EntranceController>();
  UserController get userController => read<UserController>();
}
