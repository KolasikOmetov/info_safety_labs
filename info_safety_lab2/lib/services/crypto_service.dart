import 'dart:convert';

import 'package:dart_des/dart_des.dart';

class CryptoService {
  /// Ключ для кодирования и раскодирования информации
  static const String _key = '12345678';

  /// Начальный вектор
  static const List<int> _iv = [1, 2, 3, 4, 5, 6, 7, 8];

  /// Объект-шифратор с режимом CBC
  late final DES desCBC = DES(
    key: _key.codeUnits,
    mode: DESMode.CBC,
    iv: _iv,
  );

  /// Кодирование текста в байты
  List<int> encryptToBytes(String message) {
    return desCBC.encrypt(message.codeUnits);
  }

  /// Декодирование байтов в текст
  String decryptUTF8(List<int> message) {
    return utf8.decode(desCBC.decrypt(message));
  }
}
