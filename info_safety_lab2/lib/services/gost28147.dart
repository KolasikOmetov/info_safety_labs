import 'dart:math';
import 'dart:typed_data';

// список S-boxов для замены по индексу
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

// ключ для шифрования
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

// алгоритм ГОСТ 28147. Режим гаммирования
// На входе гамма и данные для шифрования
// На выходе массив битов зашифрованных данных
List<int> gammingEn(
  Uint8List initialGamma,
  List<int> content,
) {
  // приведение гаммы к 64 битам
  initialGamma = initialGamma.length < 8
      ? Uint8List.fromList([...initialGamma, ...Iterable.generate(8 - (initialGamma.length % 8), (_) => 0)])
      : initialGamma.sublist(0, 8);

  // смена битов местами
  final List<int> biteContent = [];
  for (int code in content) {
    final bites = code.toBits(16);
    biteContent.addAll(bites.sublist(8));
    biteContent.addAll(bites.sublist(0, 8));
  }

  final data = <int>[];

  // разбиение данных на блоки по 64 бит
  final blocks =
      List<List<int>>.generate(biteContent.length ~/ 64, (index) => biteContent.sublist(index * 64, (index + 1) * 64));
  // вычисление остатка данных и добавление их отдельным блоком
  int remain = biteContent.length % 64;
  if (remain != 0) {
    blocks.add(biteContent.sublist(biteContent.length ~/ 64 * 64));
  }

  // процесс поблочного кодирования
  Uint8List gamma;
  for (final List<int> block in blocks) {
    // шифрование гаммы
    gamma = gammaStep(initialGamma);
    // подгон размера гаммы под остаток
    if (block.length < 64) {
      gamma = gamma.toBits(8).sublist(0, block.length).bitsToBytes(length: block.length ~/ 8);
    }
    // гамма и блок данных по порязрядно складываются по модулю 2
    final int encryptedBlock = gamma.fromListToInt() ^ block.toInt();

    // перевод в битовое представление
    List<int> encryptedBits = encryptedBlock.toBits(block.length);
    // сбор данных в единый массив
    data.addAll(encryptedBits);
  }

  return data;
}

// алгоритм ГОСТ 28147. Режим гаммирования
// На входе гамма и данные для расшифрования
// На выходе массив битов расшифрованных данных
List<int> gammingDe(
  Uint8List initialGamma,
  List<int> content,
) {
  // приведение гаммы к 64 битам
  initialGamma = initialGamma.length < 8
      ? Uint8List.fromList([...initialGamma, ...Iterable.generate(8 - (initialGamma.length % 8), (_) => 0)])
      : initialGamma.sublist(0, 8);

  // смена битов местами
  final List<int> biteContent = [];
  for (int code in content) {
    biteContent.addAll(code.toBits(16));
  }
  final data = <int>[];

  // разбиение данных на блоки по 64 бит
  final blocks =
      List<List<int>>.generate(biteContent.length ~/ 64, (index) => biteContent.sublist(index * 64, (index + 1) * 64));
  // вычисление остатка данных и добавление их отдельным блоком
  int remain = biteContent.length % 64;
  if (remain != 0) {
    blocks.add(biteContent.sublist(biteContent.length ~/ 64 * 64));
  }

  // процесс поблочного кодирования
  Uint8List gamma;
  for (final List<int> block in blocks) {
    // шифрование гаммы
    gamma = gammaStep(initialGamma);
    // подгон размера гаммы под остаток
    if (block.length < 64) {
      gamma = gamma.toBits(8).sublist(0, block.length).bitsToBytes(length: block.length ~/ 8);
    }
    // гамма и блок данных по порязрядно складываются по модулю 2
    final int encryptedBlock = gamma.fromListToInt() ^ block.toInt();

    // перевод в битовое представление
    List<int> encryptedBits = encryptedBlock.toBits(block.length);

    // сбор данных в единый массив
    data.addAll(encryptedBits);
  }

  // обработка перестановки байтов
  final rawCharsBlocksDecrypted = data.bitsToChars();
  final bitContent = <int>[];
  for (int code in rawCharsBlocksDecrypted) {
    final bites = code.toBits(16);
    bitContent.addAll(bites.sublist(8));
    bitContent.addAll(bites.sublist(0, 8));
  }

  // обработка битов в байты для перевода в текст
  return bitContent.bitsToChars();
}

// шаг обработки гаммы
Uint8List gammaStep(Uint8List initialGamma) {
  // кодирование гаммы основными шагами
  final Uint8List cryptoResult = process(initialGamma);

  // разделение блока на части
  final cryptoBits = cryptoResult.toBits(8);
  final middle = cryptoBits.length ~/ 2;
  var leftPart = cryptoBits.sublist(0, middle).toInt();
  var rightPart = cryptoBits.sublist(middle).toInt();

  // сложение по модулю 2^32 с постоянным значением 1010101(16).
  leftPart = (leftPart + 0x1010101) % pow(2, 32).toInt();
  if (rightPart != pow(2, 32) - 1) {
    // сложение по модулю 2^32-1 с постоянным значением 1010104(16)
    rightPart = ((rightPart + 0x1010104 - 1) % (pow(2, 32).toInt() - 1)) + 1;
  }

  // объединение частей
  final preGamma = leftPart * pow(2, 32).toInt() + rightPart;

  // кодирование гаммы основными шагами
  final gamma = process(preGamma.toBits(64).bitsToBytes());

  return gamma;
}

// получение индекса части ключа по определённому раунду
int getKeyIndex(int round, [bool isEncript = false]) {
  if (isEncript) {
    return round < 24 ? (round % 8) : 7 - (round % 8);
  }

  return round < 8 ? (round % 8) : 7 - (round % 8);
}

extension IntToBits on int {
  // перевод целочисленного значения в битовое представление
  List<int> toBits(int radix) {
    int number = this;
    final List<int> bits = <int>[];
    for (int i = 0; i < radix; i++) {
      bits.add(number & 1);
      number = number >> 1;
    }
    return bits.reversed.toList();
  }

  // отображение битов в строковом представлении
  String to2([int radix = 32]) => toBits(radix).join();
}

extension BitsToInt on List<int> {
  // перевод битов в целое число
  int toInt() {
    int result = 0;
    for (int i = 0; i < length; i++) {
      result += (elementAt(i) * pow(2, length - 1 - i)).toInt();
    }
    return result;
  }

  // биты в байты
  Uint8List bitsToBytes({int length = 8}) =>
      Uint8List.fromList(List<int>.generate(length, (index) => sublist(index * 8, (index + 1) * 8).toInt()));

  // биты в байтовое представление символов
  List<int> bitsToChars([int radix = 16]) =>
      List<int>.generate(length ~/ radix, (index) => sublist(index * radix, (index + 1) * radix).toInt());
}

extension BytesToInt on Uint8List {
  // байты в целое число
  int fromListToInt() {
    List<int> result = [];
    for (int i = 0; i < length; i++) {
      result.addAll(elementAt(i).toBits(8));
    }
    return result.toInt();
  }

  // байты в биты
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

// основной шаг алгоритма
Uint8List process(Uint8List block, {bool isEncrypte = true}) {
  // разбиение на 2 части
  var leftPart = block.sublist(0, 4).fromListToInt();
  var rightPart = block.sublist(4).fromListToInt();

  // проведение раундов
  for (int roundNumber = 0; roundNumber < 32; roundNumber++) {
    // получение индекса ключа для раунда
    final keyIndex = (getKeyIndex(roundNumber, isEncrypte));
    // получение подключа
    final subKey = key[keyIndex];
    // расчёт f функции алгоритма
    final fValue = f(leftPart, subKey);
    // правая часть и результат f функции порязрядно складываются по модулю 2
    final roundResult = rightPart ^ fValue;

    // смена частей местами
    if (roundNumber < 31) {
      rightPart = leftPart;
      leftPart = roundResult;
    } else {
      rightPart = roundResult;
    }
  }

  // вывод готового блока данных
  return [...leftPart.toBits(32), ...rightPart.toBits(32)].bitsToBytes();
}

int f(int leftPart, int subkey) {
  // сложение левой части с подключом по модулю 2(32)
  int block = (leftPart + subkey) % pow(2, 32).toInt();
  // применение S-boxов
  block = sBoxConvert(block);

  // циклический сдвиг на 11 битов
  final blockBits = block.toBits(32);
  block = [...blockBits.sublist(11), ...blockBits.sublist(0, 11)].toInt();
  return block;
}

int sBoxConvert(int block) {
  int result = 0;
  List<int> bits = block.toBits(32);
  Uint8List sBlockResults = Uint8List(8);

  // разделение на байты и определение значения замены через S-boxы
  for (var i = 0; i < 8; i++) {
    final int sIndex = (i % 2 == 0 ? bits.sublist((i + 1) * 4, (i + 2) * 4) : bits.sublist((i - 1) * 4, i * 4)).toInt();
    final int sBlock = sBoxes[i][sIndex];
    sBlockResults[i % 2 == 0 ? i + 1 : i - 1] = sBlock;
  }

  result = sBlockResults.toBits(4).toInt();
  return result;
}
