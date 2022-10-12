import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:info_safety_lab1/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

class SystemService {
  SystemService._({required this.docPath});

  final String docPath;

  static const usersDataFileName = 'users_data';

  get usersDataPath => '$docPath/$usersDataFileName';

  static Future<SystemService> init() async {
    final Directory docDirectory = await getApplicationDocumentsDirectory();
    initFiles(docDirectory);

    return SystemService._(
      docPath: docDirectory.path,
    );
  }

  static void initFiles(Directory docDirectory) {
    final String userDataFilePath = '${docDirectory.path}/$usersDataFileName';
    final File usersDataFile = File(userDataFilePath);
    if (!usersDataFile.existsSync()) {
      usersDataFile.createSync();
      final List<Map<String, dynamic>> initialUsers =
          [const UserModel(name: 'Admin', isAdmin: true)].map((e) => e.toMap()).toList();
      usersDataFile.writeAsStringSync(jsonEncode(initialUsers));
    }
  }

  List<UserModel> loadUsers() {
    final File usersDataFile = File(usersDataPath);

    if (usersDataFile.existsSync()) {
      final String data = usersDataFile.readAsStringSync();
      final List<Map<String, dynamic>> rawUsers = List.from(jsonDecode(data));
      return rawUsers.map<UserModel>((e) => UserModel.fromMap(e)).toList();
    }

    return [];
  }

  void saveUsers(List<UserModel> users) {
    final File usersDataFile = File(usersDataPath);

    if (usersDataFile.existsSync()) {
      final json = jsonEncode(users.map((e) => e.toMap()).toList());
      usersDataFile.writeAsStringSync(json);
    }
  }
}
