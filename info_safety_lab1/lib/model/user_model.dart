import 'package:info_safety_lab1/model/password_model.dart';

class UserModel {
  const UserModel({
    required this.name,
    this.isBlocked = false,
    this.isPasswordChoosingLimited = false,
    this.password = const PasswordModel(),
  });

  final String name;
  final bool isBlocked;
  final bool isPasswordChoosingLimited;
  final PasswordModel password;
}
