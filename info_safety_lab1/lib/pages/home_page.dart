import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/pages/change_password_page.dart';
import 'package:info_safety_lab1/pages/user_list_page.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/utils/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.userListController, required this.userName}) : super(key: key);

  final UserListController userListController;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UserController(userListController, userName),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.userController.user;
    final bool isAdmin = currentUser.isAdmin;
    return Scaffold(
      appBar: AppBar(
        title: Text('user: ${isAdmin ? "ADMIN" : currentUser.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OutlinedButton(
              onPressed: () => moveTo(
                  context,
                  ChangePasswordPage(
                    userController: context.userController,
                    userListController: context.userListController,
                  )),
              child: const Text('Change Password'),
            ),
            if (isAdmin)
              OutlinedButton(
                onPressed: () => moveTo(context, const UserListPage()),
                child: const Text('Open Userlist'),
              ),
            OutlinedButton(
              onPressed: () => exitProgram(),
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
