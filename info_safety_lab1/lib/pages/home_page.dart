import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_safety_lab1/controllers/user_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/pages/user_list_page.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('userMode: ' "ADMIN"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {},
              child: const Text('Change Password'),
            ),
            OutlinedButton(
              onPressed: () => moveTo(context, const UserListPage()),
              child: const Text('Open Userlist'),
            ),
            OutlinedButton(
              onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
