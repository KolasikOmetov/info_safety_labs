import 'package:info_safety_lab1/model/password_model.dart';

/// Модель пользователя
class UserModel {
  const UserModel({
    required this.name,
    this.isAdmin = false,
    this.isBlocked = false,
    this.isPasswordChoosingLimited = false,
    this.password = const PasswordModel(),
  });

  /// Имя
  final String name;

  /// Является ли пользователь администратором
  final bool isAdmin;

  /// Заблокирован ли пользователь
  final bool isBlocked;

  /// Есть ли ограничения на пароль
  final bool isPasswordChoosingLimited;

  /// Модель пароля
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

  /// Копия объекта с изменениями
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
