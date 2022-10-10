import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/change_password_controller.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/utils/utils.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key, required this.userController, required this.userListController})
      : super(key: key);

  final UserController userController;
  final UserListController userListController;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordController(userController, userListController),
      lazy: false,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => context.changePasswordController.setUsername(value),
                obscuringCharacter: '*',
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Old password",
                ),
              ),
              TextField(
                onChanged: (value) => context.changePasswordController.setPassword(value),
                obscuringCharacter: '*',
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "New password",
                ),
              ),
              OutlinedButton(
                onPressed: () => context.changePasswordController.checkData(
                    onSuccess: () => showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Password was successfully changed'),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                        ),
                    onPasswordsEquals: () => showSnack(context, 'Passwords equals'),
                    onPasswordsLimits: () =>
                        showSnack(context, 'You should use numbers, punctuation and arithmetic symbols'),
                    onPasswordWrong: () => showSnack(context, 'Password is wrong'),
                    onAccessDenied: () => showSnack(context, 'Access denied')),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
