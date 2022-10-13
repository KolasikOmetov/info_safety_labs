import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/entrance_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/pages/home_page.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/utils/utils.dart';
import 'package:info_safety_lab1/widgets/app_scafold.dart';
import 'package:provider/provider.dart';

class EntrancePage extends StatelessWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntranceController(context.userListController),
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
    return AppScaffold(
      title: 'Login',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) => context.entranceController.setUsername(value),
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
              TextField(
                onChanged: (value) => context.entranceController.setPassword(value),
                obscuringCharacter: '*',
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              OutlinedButton(
                onPressed: () => context.entranceController.checkData(
                  context: context,
                  onSuccess: (UserModel user) => moveTo(
                      context,
                      HomePage(
                        userListController: context.userListController,
                        userName: user.name,
                      )),
                  onUserNotExists: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not exists')),
                  ),
                  onUserBlocked: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User was blocked')),
                  ),
                  onPasswordWrong: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password is wrong')),
                  ),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
