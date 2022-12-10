import 'dart:typed_data';

import 'gost28147.dart';

// Gost28147
class CryptoService {
  List<int> encryptToBytes(String content, String password) {
    return encrypt(content);
  }

  /// Декодирование байтов в текст
  String decryptBytes(List<int> message, String password) {
    return decrypt(message);
  }

  List<int> gammingEncrypt(Uint8List initialGamma, List<int> bytes) {
    Uint16List data = Uint16List.fromList(bytes);
    return Uint8List.fromList(gammingEn(initialGamma, data).bitsToChars(8));
  }

  String gammingDecrypt(Uint8List initialGamma, Uint8List bytes) {
    Uint16List data = Uint16List.fromList(bytes.toBits(8).bitsToChars());
    final decryptedData = gammingDe(initialGamma, data);
    final result = String.fromCharCodes(decryptedData);
    return result;
  }
}
