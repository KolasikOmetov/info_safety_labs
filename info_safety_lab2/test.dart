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

final Uint32List key = Uint32List.fromList([32000, 400, 500, 600, 700, 800, 900, 1100]);

void main() {
  Uint32List byteContent = Uint32List.fromList('ку'.codeUnits);
  List<int> bits = [];
  for (var element in byteContent) {
    bits.addAll(element.toBits(32));
  }

  print(bits.length);
  print(bits.length % 64);

  if (bits.length % 64 != 0) {
    bits.addAll(0.toBits(32));
  }

  List<int> data = bits.sublist(0, 2);

  print('dataBefore');
  print(data);

  for (int round = 0; round < 32; round++) {
    data = calcRoundGOST(data, key[getKeyIndex(round)]);
  }

  print('dataAfter');
  print(data);
}

int getKeyIndex(int round, [bool isEncript = false]) {
  return isEncript
      ? (round < 24)
          ? round % 8
          : 7 - (round % 8)
      : (round < 8)
          ? round % 8
          : 7 - (round % 8);
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

  String get to2 => toBits(32).join();
}

extension BitsToInt on List<int> {
  int toInt() {
    int result = 0;
    for (int i = 0; i < length; i++) {
      result += (elementAt(i) * pow(2, length - 1 - i)).toInt();
    }
    return result;
  }
}

List<int> calcRoundGOST(List<int> block, int key) {
  int leftPartInit = block[0];
  print('left');
  print(leftPartInit.to2);
  int rightPartInit = block[1];
  print('right');
  print(rightPartInit.to2);

  int rightPartResult = (rightPartInit + key) % 32; // 25 - 32 round  key starts from 7
  print('key sum');
  print(rightPartResult.to2);
  List<int> sParts = rightPartResult.toBits(32);
  print(sParts.join());

  List<int> sBoxesResults = List<int>.generate(sBoxes.length, (int index) {
    final int sBoxIndex =
        sParts[index * 4] * 8 + sParts[index * 4 + 1] * 4 + sParts[index * 4 + 2] * 2 + sParts[index * 4 + 3];
    final int sBoxResult = sBoxes[index][sBoxIndex];
    return sBoxResult;
  });
  print('sBoxesResults');
  print(sBoxesResults);

  List<int> sBoxResult = [];

  for (int i = 0; i < sBoxesResults.length; i++) {
    int element = sBoxesResults[i];
    sBoxResult.addAll(element.toBits(4));
  }
  print('sBoxesResult');
  print(sBoxResult.join());

  final intSBoxResult = sBoxResult.toInt();
  print(intSBoxResult);

  final int offsetBy11Value = (intSBoxResult << 11) | (intSBoxResult >> 21);
  print('Circle offset');
  print(offsetBy11Value.to2);

  final int bitSum = offsetBy11Value | leftPartInit;
  print(leftPartInit.to2);
  print('bitSum');
  print(bitSum.to2);

  final result = [bitSum, leftPartInit];
  print('\nresult');
  print('$result\n');
  return result;
}
