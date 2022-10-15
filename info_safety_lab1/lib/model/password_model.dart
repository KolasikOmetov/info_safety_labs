import 'dart:convert';

class PasswordModel {
  const PasswordModel({this.hash = ''});

  final String hash;

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

  String toJson() => json.encode(toMap());

  factory PasswordModel.fromJson(String source) => PasswordModel.fromMap(json.decode(source));
}
