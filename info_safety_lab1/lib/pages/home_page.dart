import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/pages/change_password_page.dart';
import 'package:info_safety_lab1/pages/user_list_page.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/utils/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: UserController(user),
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
    final bool isAdmin = currentUser is AdminModel;
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
