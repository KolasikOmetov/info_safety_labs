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
}
