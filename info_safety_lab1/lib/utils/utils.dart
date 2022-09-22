import 'package:flutter/material.dart';

Future<void> moveTo(BuildContext context, Widget page) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
