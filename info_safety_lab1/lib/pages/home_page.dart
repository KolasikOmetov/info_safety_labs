import 'package:flutter/material.dart';
import 'package:info_safety_lab1/pages/user_list_page.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          ],
        ),
      ),
    );
  }
}
