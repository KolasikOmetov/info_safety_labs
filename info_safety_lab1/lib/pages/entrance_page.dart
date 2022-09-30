import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/entrance_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/pages/home_page.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/utils/utils.dart';
import 'package:provider/provider.dart';

class EntrancePage extends StatelessWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntranceController(),
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
        title: const Text('userMode: ' "ADMIN"),
      ),
      body: Center(
        child: Column(
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
                onSuccess: (UserModel user) => moveTo(context, HomePage(user: user)),
                onUserNotExists: () => const ScaffoldMessenger(child: Text('User not exists')),
                onPasswordWrong: () => const ScaffoldMessenger(child: Text('Password is wrong')),
              ),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
