import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:info_safety_lab1/model/user_model.dart';
import 'package:info_safety_lab1/services/crypto_service.dart';
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
    initFiles(docDirectory, tempDirectory, cryptoService);

    return SystemService._(
      cryptoService,
      docPath: docDirectory.path,
      tempPath: tempDirectory.path,
    );
  }

  /// Загрузка файлов при инициализации приложения
  static Future<void> initFiles(Directory docDirectory, Directory tempDirectory, CryptoService cryptoService) async {
    final String tempUserDataFilePath = '${tempDirectory.path}/$tmpUsersDataFileName';
    final File tempUsersDataFile = File(tempUserDataFilePath);
    final String docUserDataFilePath = '${docDirectory.path}/$usersDataFileName';
    final File docUsersDataFile = File(docUserDataFilePath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();

      /// Первый пользователь ADMIN
      final List<Map<String, dynamic>> initialUsers =
          [const UserModel(name: 'ADMIN', isAdmin: true)].map((e) => e.toMap()).toList();
      docUsersDataFile.writeAsBytesSync(cryptoService.encryptToBytes(jsonEncode(initialUsers)));
    }

    if (!tempUsersDataFile.existsSync()) {
      tempUsersDataFile.createSync();
    }

    /// Получение расшифрованных данных
    final String content = cryptoService.decryptUTF8(docUsersDataFile.readAsBytesSync());
    tempUsersDataFile.writeAsStringSync(content);
  }

  /// Сохранение данных перед выходом из программы
  void saveDataBeforeExit() {
    final File tempUsersDataFile = File(tempUsersDataPath);
    final File docUsersDataFile = File(docUsersDataPath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();
    }

    final String content = tempUsersDataFile.readAsStringSync();

    /// Шифрование новых данных в защищённый файл
    docUsersDataFile.writeAsBytesSync(_cryptoService.encryptToBytes(jsonEncode(content)));

    /// Удаление временного файла
    tempUsersDataFile.deleteSync();
  }

  /// Загрузка списка пользователей из временного файла
  List<UserModel> loadUsers() {
    final File usersDataFile = File(tempUsersDataPath);

    if (usersDataFile.existsSync()) {
      final String data = usersDataFile.readAsStringSync();
      dynamic map = jsonDecode(data);
      if (map is String) {
        map = jsonDecode(map);
      }
      final List<Map<String, dynamic>> rawUsers = List.from(map);
      return rawUsers.map<UserModel>((e) => UserModel.fromMap(e)).toList();
    }
    return [];
  }

  /// Сохранение текущих данных пользователей во временный файл
  void saveUsers(List<UserModel> users) {
    final File usersDataFile = File(tempUsersDataPath);

    if (usersDataFile.existsSync()) {
      final json = jsonEncode(users.map((e) => e.toMap()).toList());
      usersDataFile.writeAsStringSync(json);
    }
  }
}
