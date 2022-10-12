import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/utils/context_x.dart';
import 'package:info_safety_lab1/widgets/dialogs/add_user_dialog.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: const _Content(),
      resizeToAvoidBottomInset: false,
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

  _addUser(BuildContext context) async {
    final UserListController userListController = context.userListController;
    final String? newUserName =
        await AddUserDialog.show(context, isExists: (username) => userListController.isUserExists(username));
    if (newUserName != null) {
      userListController.addNewUserByName(newUserName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Consumer<UserListController>(builder: (BuildContext context, UserListController value, Widget? child) {
            final users = value.users;
            if (users.isEmpty) {
              return const Center(
                child: Text('Empty User List'),
              );
            }
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                final UserModel user = users[index];
                return Row(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SelectableText(user.name),
                    )),
                    if (!user.isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: OutlinedButton(
                          onPressed: () => _onBlockPressed(context, user),
                          child: Text(user.isBlocked ? 'Unblock' : 'Block'),
                        ),
                      ),
                    if (!user.isAdmin)
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: OutlinedButton(
                          onPressed: () => _onLimitPressed(context, user),
                          child: Text(user.isPasswordChoosingLimited ? 'Unlimit Passwords' : 'Limit Passwords'),
                        ),
                      ),
                    if (user.isAdmin)
                      const Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text('Admin Account'),
                      ),
                  ],
                );
              },
            );
          }),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: OutlinedButton(
            onPressed: () => _addUser(context),
            child: const Text('Add user'),
          ),
        )
      ],
    );
  }
}
