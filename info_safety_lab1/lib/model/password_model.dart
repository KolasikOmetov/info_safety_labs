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
}
