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
  // Uint32List byteContent = Uint32List.fromList('fignay_polnaya'.codeUnits);
  Uint32List byteContent = Uint32List.fromList([32000, 42949672, 2048, 1023]);
  int leftPartInit = byteContent[0];
  print(leftPartInit.toRadixString(2));
  int rightPartInit = byteContent[1];
  print(rightPartInit.toRadixString(2));

  int rightPartResult = rightPartInit ^ key[0];
  print(rightPartResult.toRadixString(2));
  List<int> sParts = List<int>.generate(32, (int index) {
    final int bit = rightPartResult & 1;
    rightPartResult = rightPartResult >> 1;
    return bit;
  }).reversed.toList();

  List<int> sBoxesResults = List<int>.generate(sBoxes.length, (int index) {
    final int sBoxIndex =
        sParts[index * 4] * 8 + sParts[index * 4 + 1] * 4 + sParts[index * 4 + 2] * 2 + sParts[index * 4 + 3];
    final int sBoxResult = sBoxes[index][sBoxIndex];
    return sBoxResult;
  });
  print(sBoxesResults);

  final int sBoxResult = sBoxesResults.;
}
