import 'dart:typed_data';

import 'gost28147.dart';

// Gost28147
class CryptoService {
  // Декодирование байтов в текст
  List<int> gammingEncrypt(Uint8List initialGamma, List<int> bytes) {
    // преобразование битов в байты
    return Uint8List.fromList(gammingEn(initialGamma, bytes));
  }

  String gammingDecrypt(Uint8List initialGamma, Uint8List bytes) {
    // расширение представления int
    Uint16List data = Uint16List.fromList(bytes.toBits(8).bitsToChars());
    // расшифровка с применением гаммы
    final decryptedData = gammingDe(initialGamma, data);
    // первод байтов в символы
    final result = String.fromCharCodes(decryptedData);
    return result;
  }
}
