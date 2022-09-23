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

  UserModel copyWith({
    String? name,
    bool? isBlocked,
    bool? isPasswordChoosingLimited,
    PasswordModel? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      isBlocked: isBlocked ?? this.isBlocked,
      isPasswordChoosingLimited: isPasswordChoosingLimited ?? this.isPasswordChoosingLimited,
      password: password ?? this.password,
    );
  }
}

class AdminModel extends UserModel {
  const AdminModel({
    super.isBlocked = false,
    super.isPasswordChoosingLimited = false,
    super.password = const PasswordModel(),
  }) : super(name: 'admin');
}
