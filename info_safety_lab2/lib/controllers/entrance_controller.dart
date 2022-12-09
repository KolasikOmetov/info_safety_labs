import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  void setPassword(password) => this.password = password;

  /// Проверка введенных данных пользователем
  void checkData({
    required BuildContext context,
    required void Function() onSuccess,
  }) {
    onSuccess();
  }

  void setPathFrom() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathFrom = filepath;
      notifyListeners();
    }
  }

  void setPasswordPath() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathPassword = filepath;
      notifyListeners();
    }
  }

  void setPathTo() async {
    String? filepath = await SystemService.chooseFile();
    if (filepath != null) {
      pathTo = filepath;
      notifyListeners();
    }
  }

  void encrypt({
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
      final String oldContent = await systemService.readFile(pathFrom);
      String userPassword = '';
      if (password.isNotEmpty) {
        userPassword = password;
      } else {
        if (pathPassword == null) {
          onError('Password must be set');
          return;
        }
        userPassword = await systemService.readFile(pathPassword);
      }

      final List<int> ecrypted = cryptoService.encryptToBytes(oldContent, userPassword);
      systemService.writeFile(pathTo, ecrypted);
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
        userPassword = await systemService.readFile(pathPassword);
      }
      final Uint8List encrypted = await systemService.readFileAsBytes(pathFrom);

      final String newContent = cryptoService.decryptBytes(encrypted, userPassword);
      debugPrintSynchronously('decrypted: $newContent');
      systemService.writeFile(pathTo, newContent.codeUnits);
    } catch (e) {
      onError(e.toString());
      return;
    }
    onSuccess('File $pathFrom was decrypted in file $pathTo');
  }
}
