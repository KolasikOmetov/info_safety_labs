import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> moveTo(BuildContext context, Widget page) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

void exitProgram() => SystemChannels.platform.invokeMethod('SystemNavigator.pop');
