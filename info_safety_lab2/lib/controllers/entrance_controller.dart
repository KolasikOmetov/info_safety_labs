import 'package:flutter/foundation.dart';
import 'package:info_safety_lab2/services/crypto_service.dart';
import 'package:info_safety_lab2/services/system_service.dart';

class EntranceController extends ChangeNotifier {
  EntranceController(this.systemService, this.cryptoService);

  final SystemService systemService;
  final CryptoService cryptoService;
  String password = '';
  String? pathPassword;
  String? pathFrom;
  String? pathTo;

  // установка пароля
  void setPassword(password) => this.password = password;

  // установка пути откуда будем брать данные
  void setPathFrom() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathFrom = filepath;
      notifyListeners();
    }
  }

  // установка пути откуда будем пароль
  void setPasswordPath() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathPassword = filepath;
      notifyListeners();
    }
  }

  // установка пути куда будем сохранять данные
  void setPathTo() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathTo = filepath;
      notifyListeners();
    }
  }

  // процесс шифрования
  void encrypt({
    required void Function(String text) onError,
    required void Function(String text) onSuccess,
  }) async {
    final pathTo = this.pathTo;
    final pathFrom = this.pathFrom;
    final pathPassword = this.pathPassword;

    // проверки на пустоту
    if (pathTo == null) {
      onError('Path "To" must be set');
      return;
    }
    if (pathFrom == null) {
      onError('Path "From" must be set');
      return;
    }

    try {
      String userPassword = '';
      if (password.isNotEmpty) {
        userPassword = password;
      } else {
        if (pathPassword == null) {
          onError('Password must be set');
          return;
        }
        // если пароль не введён то устанавливаем его из файла
        userPassword = await systemService.readFile(pathPassword);
      }

      // загрузка контента из файла в виде байтов
      final List<int> oldContent = await systemService.readFileAsBytes(pathFrom);
      // шифрование контента алгоритмом ГОСТ-28147 в режиме гаммирования
      final List<int> encrypted = cryptoService.gammingEncrypt(Uint8List.fromList(userPassword.codeUnits), oldContent);

      // запись в файл зашифрованных байтов
      systemService.writeFile(pathTo, encrypted);
    } catch (e) {
      onError(e.toString());
      return;
    }
    onSuccess('File $pathFrom was encrypted in file $pathTo');
  }

  void decrypt({
    required void Function(String text) onError,
    required void Function(String text) onSuccess,
  }) async {
    final pathTo = this.pathTo;
    final pathFrom = this.pathFrom;
    final pathPassword = this.pathPassword;

    if (pathTo == null) {
      onError('Path "To" must be set');
      return;
    }
    if (pathFrom == null) {
      onError('Path "From" must be set');
      return;
    }

    try {
      String userPassword = '';
      if (password.isNotEmpty) {
        userPassword = password;
      } else {
        if (pathPassword == null) {
          onError('Password must be set');
          return;
        }
        // если пароль не введён то устанавливаем его из файла
        userPassword = await systemService.readFile(pathPassword);
      }
      // загрузка контента из файла в виде байтов
      final Uint8List encrypted = await systemService.readFileAsBytes(pathFrom);

      // расшифровка контента алгоритмом ГОСТ-28147 в режиме гаммирования происходит по тому же алгоритму, что и шифрование
      final String newContent = cryptoService.gammingDecrypt(Uint8List.fromList(userPassword.codeUnits), encrypted);
      debugPrintSynchronously('decrypted: $newContent');
      // запись в файл расшифрованных байтов
      systemService.writeFile(pathTo, newContent.codeUnits);
    } catch (e) {
      onError(e.toString());
      return;
    }
    onSuccess('File $pathFrom was decrypted in file $pathTo');
  }
}
