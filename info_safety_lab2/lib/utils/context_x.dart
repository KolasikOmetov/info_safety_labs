import 'package:flutter/widgets.dart';
import 'package:info_safety_lab2/controllers/entrance_controller.dart';
import 'package:provider/provider.dart';

extension ContextX on BuildContext {
  EntranceController get entranceController => read<EntranceController>();
}
