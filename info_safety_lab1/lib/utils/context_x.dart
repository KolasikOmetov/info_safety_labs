import 'package:flutter/widgets.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:provider/provider.dart';

extension ContextX on BuildContext {
  UserListController get userListController => read<UserListController>();
}
