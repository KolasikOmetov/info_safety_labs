/// Модель пароля
class PasswordModel {
  const PasswordModel({this.hash = ''});

  /// Хеш пароля пользователя
  /// может быть пустым если у пользователя не установлен пароль
  final String hash;

  /// Копия объекта с изменениями
  PasswordModel copyWith({
    String? hash,
  }) {
    return PasswordModel(
      hash: hash ?? this.hash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
    };
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      hash: map['hash'] ?? '',
    );
  }
}
