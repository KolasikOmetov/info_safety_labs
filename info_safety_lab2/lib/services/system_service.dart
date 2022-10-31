import 'dart:async';
import 'dart:io';

import 'package:info_safety_lab2/services/crypto_service.dart';
import 'package:path_provider/path_provider.dart';

class SystemService {
  SystemService._(this._cryptoService, {required this.tempPath, required this.docPath});

  final String docPath;
  final String tempPath;
  final CryptoService _cryptoService;

  /// Файлы для хранения данных
  ///
  /// Зашифрованный и постоянный
  static const usersDataFileName = 'users_data';

  /// Открытый и временный
  static const tmpUsersDataFileName = 'tmp_users_data';

  String get docUsersDataPath => '$docPath/$usersDataFileName';
  String get tempUsersDataPath => '$tempPath/$tmpUsersDataFileName';

  static Future<SystemService> init() async {
    /// Папка с постоянными документами приложения
    final Directory docDirectory = await getApplicationDocumentsDirectory();

    /// Папка кэша приложения
    final Directory tempDirectory = await getTemporaryDirectory();
    final CryptoService cryptoService = CryptoService();

    return SystemService._(
      cryptoService,
      docPath: docDirectory.path,
      tempPath: tempDirectory.path,
    );
  }
}
