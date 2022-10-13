import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:info_safety_lab1/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

class SystemService {
  SystemService._({required this.tempPath, required this.docPath});

  final String docPath;
  final String tempPath;

  static const usersDataFileName = 'users_data';

  String get docUsersDataPath => '$docPath/$usersDataFileName';
  String get tempUsersDataPath => '$tempPath/$usersDataFileName';

  static Future<SystemService> init() async {
    final Directory docDirectory = await getApplicationDocumentsDirectory();
    final Directory tempDirectory = await getTemporaryDirectory();
    initFiles(docDirectory, tempDirectory);

    return SystemService._(
      docPath: docDirectory.path,
      tempPath: tempDirectory.path,
    );
  }

  static void initFiles(Directory docDirectory, Directory tempDirectory) {
    final String tempUserDataFilePath = '${tempDirectory.path}/$usersDataFileName';
    final File tempUsersDataFile = File(tempUserDataFilePath);
    final String docUserDataFilePath = '${tempDirectory.path}/$usersDataFileName';
    final File docUsersDataFile = File(docUserDataFilePath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();
      final List<Map<String, dynamic>> initialUsers =
          [const UserModel(name: 'Admin', isAdmin: true)].map((e) => e.toMap()).toList();
      docUsersDataFile.writeAsStringSync(jsonEncode(initialUsers));
    }

    if (!tempUsersDataFile.existsSync()) {
      tempUsersDataFile.createSync();
    }
    final String content = docUsersDataFile.readAsStringSync();
    tempUsersDataFile.writeAsStringSync(content);
  }

  void saveData() {
    final File tempUsersDataFile = File(tempUsersDataPath);
    final File docUsersDataFile = File(docUsersDataPath);
    if (!docUsersDataFile.existsSync()) {
      docUsersDataFile.createSync();
    }

    final String content = tempUsersDataFile.readAsStringSync();
    docUsersDataFile.writeAsStringSync(content);
  }

  List<UserModel> loadUsers() {
    final File usersDataFile = File(tempUsersDataPath);

    if (usersDataFile.existsSync()) {
      final String data = usersDataFile.readAsStringSync();
      final List<Map<String, dynamic>> rawUsers = List.from(jsonDecode(data));
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
