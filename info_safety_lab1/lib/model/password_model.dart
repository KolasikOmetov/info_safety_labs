import 'dart:convert';

class PasswordModel {
  const PasswordModel({this.text = ''});

  final String text;

  PasswordModel copyWith({
    String? text,
  }) {
    return PasswordModel(
      text: text ?? this.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
    };
  }

  factory PasswordModel.fromMap(Map<String, dynamic> map) {
    return PasswordModel(
      text: map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PasswordModel.fromJson(String source) => PasswordModel.fromMap(json.decode(source));
}
