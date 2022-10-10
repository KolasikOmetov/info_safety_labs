import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SystemService {
  SystemService._({required this.docPath});

  final String docPath;

  static const usersDataFileName = 'users_data';

  get usersDataPath => '$docPath/$usersDataFileName';

  static Future<SystemService> init() async {
    final Directory docDirectory = await getApplicationDocumentsDirectory();
    await initFiles(docDirectory);

    return SystemService._(
      docPath: docDirectory.path,
    );
  }

  static Future<void> initFiles(Directory docDirectory) async {
    final String userDataFilePath = '${docDirectory.path}/$usersDataFileName';
    await File(userDataFilePath).create();
  }



  Future<> loadUsers() async {
    final Directory libDirectory = Directory(_libPath);
    await exactlyExists(libDirectory);

    final List<Directory> dirs =
        libDirectory.listSync().whereType<Directory>().cast<Directory>().toList(growable: false);

    final List<PreviewSongModel> songs = List<PreviewSongModel>.generate(
      dirs.length,
      (int index) {
        final Directory dir = dirs[index];

        return PreviewSongDTO.fromDir(dir: dir).model;
      },
    );

    return songs;
  }

  Future<void> exactlyExists(Directory dir) async {
    if (!(await dir.exists())) {
      await dir.create();
    }
  }

  static Future<String?> pickFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    return result?.files.single.path;
  }

  Future<SongModel> saveSong(SongModel model) async {
    final String dateId = DateFormat('yyyy.MM.dd hh:mm:ss').format(model.dateCreation);
    final String songDirName = '$docPath/[$dateId] ${model.title}';
    await Directory(songDirName).create();

    final String audioFileName = basename(model.songPath);
    final File externalAudioFile = File(model.songPath);
    final File internalAudioFile = await externalAudioFile.copy('$songDirName/$audioFileName');

    final String subsFileName = basename(model.subsPath);
    final File externalSubsFile = File(model.subsPath);
    final File internalSubsFile = await externalSubsFile.copy('$songDirName/$subsFileName');

    final SongModel newModel = model.copyWith(songPath: internalAudioFile.path, subsPath: internalSubsFile.path);

    final String configName = '$songDirName/config.txt';
    final File configFile = await File(configName).create();
    await configFile.writeAsString(_generateConfig(newModel));

    return newModel;
  }

  String _generateConfig(SongModel model) {
    return jsonEncode(model.dto.toJson());
  }
}
