import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> moveTo(BuildContext context, Widget page) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void exitProgram(BuildContext context) {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text)),
  );
}

/// Хеширование пароля с помощью алгоритма sha256
String hashPassword(String password) {
  if (password.isEmpty) {
    return '';
  }
  return sha256.convert(utf8.encode(password)).toString();
}
