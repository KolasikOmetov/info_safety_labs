import 'package:flutter/material.dart';
import 'package:info_safety_lab2/utils/utils.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({Key? key, required this.title, required this.body}) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          TextButton(
            onPressed: () => exitProgram(context),
            child: Text(
              'Exit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: body,
      resizeToAvoidBottomInset: false,
    );
  }
}
