import 'dart:math';
import 'dart:typed_data';

const sBoxes = [
  [4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3],
  [14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9],
  [5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11],
  [7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3],
  [6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2],
  [4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14],
  [13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12],
  [1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12],
];

final Uint32List key = Uint32List.fromList([
  0xF904C1E2,
  0xDE7C1DE4,
  0x57E8E57F,
  0xB4650206,
  0x85CC1C28,
  0x9A922C2E,
  0x03454647,
  0x10E50CE0,
]);

final Uint8List initialGamma = Uint8List.fromList([0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04]);
// final Uint8List initialGamma = Uint8List.fromList([0x71, 0x3F, 0xA2, 0xD7, 0xB5,0x84,0x29,0x5C]);

void main() {
  Uint16List unicodes = Uint16List.fromList('hello, world!'.codeUnits);
  print(unicodes);

  final List<int> biteContent = [];
  for (int code in unicodes) {
    final bites = code.toBits(16);
    biteContent.addAll(bites.sublist(8));
    biteContent.addAll(bites.sublist(0, 8));
  }
  final blocks =
      List<List<int>>.generate(biteContent.length ~/ 64, (index) => biteContent.sublist(index * 64, (index + 1) * 64));
  int remain = biteContent.length % 64;
  if (remain != 0) {
    blocks.add(biteContent.sublist(biteContent.length ~/ 64 * 64));
  }

  var gamma = initialGamma;

  final cryptoData = <int>[];
  final decryptedData = <int>[];

  for (final List<int> block in blocks) {
    gamma = gammaStep(gamma);

    if (block.length < 64) {
      gamma = gamma.toBits(8).sublist(0, block.length).bitsToBytes(length: block.length ~/ 8);
    }
    final int decryptedBlock = gamma.toInt() ^ block.toInt();

    List<int> decryptedBits = decryptedBlock.toBits(64);

    decryptedData.addAll(decryptedBits);

    gamma = decryptedBits.bitsToBytes();
  }

  final List<List<int>> blocksEncrypted =
      List<List<int>>.generate(cryptoData.length ~/ 64, (index) => cryptoData.sublist(index * 64, (index + 1) * 64));

  for (final List<int> block in blocksEncrypted) {
    gamma = gammaStep(gamma);
    if (block.length < 64) {
      gamma = gamma.toBits(8).sublist(0, block.length).bitsToBytes(length: block.length ~/ 8);
    }
    final int encryptedBlock = gamma.toInt() ^ block.toInt();

    List<int> encryptedBits = encryptedBlock.toBits(64);

    cryptoData.addAll(encryptedBits);

    gamma = encryptedBits.bitsToBytes();
  }

  final charsBlocksEncrypted = cryptoData.bitsToChars(cryptoData.length ~/ 16);
  print(charsBlocksEncrypted);
  try {
    print(String.fromCharCodes(charsBlocksEncrypted));
  } catch (e) {
    print(e);
  }

  final rawCharsBlocksDecrypted = decryptedData.bitsToChars(decryptedData.length ~/ 16);
  final bitContent = <int>[];
  for (int code in rawCharsBlocksDecrypted) {
    final bites = code.toBits(16);
    bitContent.addAll(bites.sublist(8));
    bitContent.addAll(bites.sublist(0, 8));
  }

  final charsBlocksDecrypted = bitContent.bitsToChars(bitContent.length ~/ 16);

  try {
    print(String.fromCharCodes(charsBlocksDecrypted));
  } catch (e) {
    print(e);
  }
}

int getKeyIndex(int round, [bool isEncript = false]) {
  if (isEncript) {
    return round < 24 ? (round % 8) : 7 - (round % 8);
  }

  return round < 8 ? (round % 8) : 7 - (round % 8);
}

extension IntToBits on int {
  List<int> toBits(int radix) {
    int number = this;
    final List<int> bits = <int>[];
    for (int i = 0; i < radix; i++) {
      bits.add(number & 1);
      number = number >> 1;
    }
    return bits.reversed.toList();
  }

  String to2({int radix = 32}) => toBits(radix).join();
}

extension BitsToInt on List<int> {
  int toInt() {
    int result = 0;
    for (int i = 0; i < length; i++) {
      result += (elementAt(i) * pow(2, length - 1 - i)).toInt();
    }
    return result;
  }

  Uint8List bitsToBytes({int length = 8}) =>
      Uint8List.fromList(List<int>.generate(length, (index) => sublist(index * 8, (index + 1) * 8).toInt()));

  List<int> bitsToChars(int length) =>
      List<int>.generate(length, (index) => sublist(index * 16, (index + 1) * 16).toInt());
}

extension BytesToInt on Uint8List {
  int fromListToInt() {
    List<int> result = [];
    for (int i = 0; i < length; i++) {
      result.addAll(elementAt(i).toBits(8));
    }
    return result.toInt();
  }

  List<int> toBits(int radix) {
    final List<int> allBits = <int>[];
    for (int i = 0; i < length; i++) {
      final List<int> bits = <int>[];
      int number = elementAt(i);
      for (int j = 0; j < radix; j++) {
        bits.add(number & 1);
        number = number >> 1;
      }
      allBits.addAll(bits.reversed);
    }
    return allBits;
  }
}

Uint8List process(Uint8List block, {bool isEncrypte = true}) {
  var leftPart = block.sublist(0, 4).fromListToInt();
  var rightPart = block.sublist(4).fromListToInt();

  for (int roundNumber = 0; roundNumber < 32; roundNumber++) {
    final keyIndex = (getKeyIndex(roundNumber, isEncrypte));
    print('\nkeyIndex: $keyIndex');
    final subKey = key[keyIndex];
    print(subKey);
    final fValue = f(leftPart, subKey);
    final roundResult = rightPart ^ fValue;
    if (roundNumber < 31) {
      rightPart = leftPart;
      leftPart = roundResult;
    } else {
      rightPart = roundResult;
    }
  }

  return [...leftPart.toBits(32), ...rightPart.toBits(32)].bitsToBytes();
}

int f(int leftPart, int subkey) {
  int block = (leftPart + subkey) % pow(2, 32).toInt();
  block = sBoxConvert(block);

  final blockBits = block.toBits(32);
  block = [...blockBits.sublist(11), ...blockBits.sublist(0, 11)].toInt();
  return block;
}

int sBoxConvert(int block) {
  int result = 0;
  List<int> bits = block.toBits(32);
  Uint8List sBlockResults = Uint8List(8);

  for (var i = 0; i < 8; i++) {
    final int sIndex = (i % 2 == 0 ? bits.sublist((i + 1) * 4, (i + 2) * 4) : bits.sublist((i - 1) * 4, i * 4)).toInt();
    final int sBlock = sBoxes[i][sIndex];
    sBlockResults[i % 2 == 0 ? i + 1 : i - 1] = sBlock;
  }
  print(sBlockResults);

  result = sBlockResults.toBits(4).toInt();
  return result;
}

Uint8List gammaStep(Uint8List initialGamma) {
  final Uint8List cryptoResult = process(initialGamma);
  print(cryptoResult);

  final cryptoBits = cryptoResult.toBits(8);
  final middle = cryptoBits.length ~/ 2;
  var leftPart = cryptoBits.sublist(0, middle).toInt();
  var rightPart = cryptoBits.sublist(middle).toInt();

  leftPart = (leftPart + 0x1010104) % pow(2, 32).toInt();
  if (rightPart != pow(2, 32) - 1) {
    rightPart = (rightPart + 0x1010101 - 1) % (pow(2, 32).toInt() - 1) + 1;
  }

  print(leftPart.to2());
  print(rightPart.to2());

  final preGamma = leftPart * pow(2, 32).toInt() + rightPart;
  print(preGamma);

  final gamma = process(preGamma.toBits(64).bitsToBytes());

  return gamma;
}
