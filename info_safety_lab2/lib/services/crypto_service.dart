import 'dart:convert';
import 'dart:typed_data';


// Gost28147
class CryptoService {
  final List<int> key = [300, 400, 500, 600, 700, 800, 900, 1100];

  static const kRoundAmount = 32;
  static const sBoxes = [
    [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
    [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
    [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
    [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
    [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
    [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
    [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
    [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12],
  ];

  List<int> encryptToBytes(String content, String password) {
    Uint32List byteContent = Uint32List.fromList(content.codeUnits) ;

    for (int byteIndex = 0; byteIndex < byteContent.length; byteIndex += 2) {
      int leftPartInit = byteContent[byteIndex];
      int rightPartInit = byteContent[byteIndex];
      for (int round = 0; round < kRoundAmount; round++) {
        int rightPartResult = rightPartInit & leftPartInit;

        rightPartResult = ;

        rightPartInit = leftPartInit;
      }
    }
  }

  /// Декодирование байтов в текст
  String decryptUTF8(List<int> message) {
    return utf8.decode(desCBC.decrypt(message));
  }
}
