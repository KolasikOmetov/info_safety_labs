import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class SystemService {
  static Future<String?> chooseFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    return result?.files.single.path;
  }

  static Future<String?> chooseSaveFilePath() => FilePicker.platform.saveFile();

  Future<void> writeFile(String path, List<int> bytes) => File(path).writeAsBytes(bytes);

  Future<String> readFile(String path) => File(path).readAsString();
}
