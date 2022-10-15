import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:info_safety_lab1/services/system_service.dart';
import 'package:provider/provider.dart';

Future<void> moveTo(BuildContext context, Widget page) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void exitProgram(BuildContext context) {
  context.read<SystemService>().saveDataBeforeExit();
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

String hashPassword(String password) {
  if (password.isEmpty) {
    return '';
  }
  return sha256.convert(utf8.encode(password)).toString();
}
