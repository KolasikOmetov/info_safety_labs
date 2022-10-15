import 'dart:convert';

import 'package:dart_des/dart_des.dart';

class CryptoService {
  static const String _key = '12345678'; // 24-byte
  static const List<int> _iv = [1, 2, 3, 4, 5, 6, 7, 8];

  late final DES desCBC = DES(
    key: _key.codeUnits,
    mode: DESMode.CBC,
    iv: _iv,
  );

  List<int> encryptToBytes(String message) {
    return desCBC.encrypt(message.codeUnits);
  }

  String decryptUTF8(List<int> message) {
    return utf8.decode(desCBC.decrypt(message));
  }
}
