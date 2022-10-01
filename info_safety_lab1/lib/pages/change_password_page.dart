import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/change_password_controller.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordController(context.userController),
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
                  onPasswordsEquals: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not exists')),
                  ),
                  onPasswordsLimits: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User was blocked')),
                  ),
                  onPasswordWrong: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password is wrong')),
                  ),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
