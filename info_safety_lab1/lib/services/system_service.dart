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

  static const usersDataFileName = 'users_data';
  static const tmpUsersDataFileName = 'tmp_users_data';

  String get docUsersDataPath => '$docPath/$usersDataFileName';
  String get tempUsersDataPath => '$tempPath/$tmpUsersDataFileName';

  static Future<SystemService> init() async {
    final Directory docDirectory = await getApplicationDocumentsDirectory();
    final Directory tempDirectory = await getTemporaryDirectory();
    final CryptoService cryptoService = CryptoService();
    initFiles(docDirectory, tempDirectory, cryptoService);

    return SystemService._(
      cryptoService,
      docPath: docDirectory.path,
      tempPath: tempDirectory.path,
    );
  }

  static Future<void> initFiles(Directory docDirectory, Directory tempDirectory, CryptoService cryptoService) async {
    final String tempUserDataFilePath = '${tempDirectory.path}/$tmpUsersDataFileName';
    final File tempUsersDataFile = File(tempUserDataFilePath);
    final String docUserDataFilePath = '${docDirectory.path}/$usersDataFileName';
    final File docUsersDataFile = File(docUserDataFilePath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();
      final List<Map<String, dynamic>> initialUsers =
          [const UserModel(name: 'ADMIN', isAdmin: true)].map((e) => e.toMap()).toList();
      docUsersDataFile.writeAsBytesSync(cryptoService.encryptToBytes(jsonEncode(initialUsers)));
    }

    if (!tempUsersDataFile.existsSync()) {
      tempUsersDataFile.createSync();
    }
    final String content = cryptoService.decryptUTF8(docUsersDataFile.readAsBytesSync());
    tempUsersDataFile.writeAsStringSync(content);
  }

  void saveDataBeforeExit() {
    final File tempUsersDataFile = File(tempUsersDataPath);
    final File docUsersDataFile = File(docUsersDataPath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();
    }

    final String content = tempUsersDataFile.readAsStringSync();
    docUsersDataFile.writeAsBytesSync(_cryptoService.encryptToBytes(jsonEncode(content)));
    tempUsersDataFile.deleteSync();
  }

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

  void saveUsers(List<UserModel> users) {
    final File usersDataFile = File(tempUsersDataPath);

    if (usersDataFile.existsSync()) {
      final json = jsonEncode(users.map((e) => e.toMap()).toList());
      usersDataFile.writeAsStringSync(json);
    }
  }
}
