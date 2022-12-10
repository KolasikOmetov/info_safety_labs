import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class SystemService {
  static Future<String?> chooseFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();

    return result?.files.single.path;
  }

  Future<void> writeFile(String path, List<int> bytes) => File(path).writeAsBytes(bytes);

  Future<String> readFile(String path) => File(path).readAsString();

  Future<Uint8List> readFileAsBytes(String path) => File(path).readAsBytes();
}
