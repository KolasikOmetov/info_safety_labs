import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => UserListController(),
        child: const _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  _onLimitPressed(BuildContext context, UserModel user) {
    context.userListController.setUserLimit(user, !user.isPasswordChoosingLimited);
  }

  _onBlockPressed(BuildContext context, UserModel user) {
    context.userListController.setUserBlock(user, !user.isBlocked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          child: Consumer<UserListController>(
            builder: (BuildContext context, UserListController value, Widget? child) {
              return ListView.builder(
                itemCount: value.users.length,
                itemBuilder: (BuildContext context, int index) {
                  final UserModel user = value.users[index];
                  return ListTile(
                    title: Text(user.name),
                    trailing: Row(
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () => _onBlockPressed(context, user),
                          child: Text(user.isBlocked ? 'Unblock' : 'Block'),
                        ),
                        OutlinedButton(
                          onPressed: () => _onLimitPressed(context, user),
                          child: Text(user.isPasswordChoosingLimited ? 'Unlimit Passwords' : 'Limit Passwords'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          child: OutlinedButton(
            onPressed: () => _,
            child: const Text('Add user'),
          ),
        )
      ],
    );
  }
}
