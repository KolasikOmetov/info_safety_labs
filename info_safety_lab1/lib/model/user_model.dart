import 'package:info_safety_lab1/model/password_model.dart';

class UserModel {
  const UserModel({
    required this.name,
    this.isAdmin = false,
    this.isBlocked = false,
    this.isPasswordChoosingLimited = false,
    this.password = const PasswordModel(),
  });

  final String name;
  final bool isAdmin;
  final bool isBlocked;
  final bool isPasswordChoosingLimited;
  final PasswordModel password;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isAdmin': isAdmin,
      'isBlocked': isBlocked,
      'isPasswordChoosingLimited': isPasswordChoosingLimited,
      'password': password.toMap(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
      isPasswordChoosingLimited: map['isPasswordChoosingLimited'] ?? false,
      password: PasswordModel.fromMap(map['password']),
    );
  }

  UserModel copyWith({
    String? name,
    bool? isAdmin,
    bool? isBlocked,
    bool? isPasswordChoosingLimited,
    PasswordModel? password,
  }) {
    return UserModel(
      name: name ?? this.name,
      isAdmin: isAdmin ?? this.isAdmin,
      isBlocked: isBlocked ?? this.isBlocked,
      isPasswordChoosingLimited: isPasswordChoosingLimited ?? this.isPasswordChoosingLimited,
      password: password ?? this.password,
    );
  }
}
