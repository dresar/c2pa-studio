import 'dart:io' as io;
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<void> saveFileBytes(Uint8List bytes, String filename) async {
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Save export',
    fileName: filename,
  );
  if (outputFile != null) {
    final file = io.File(outputFile);
    await file.writeAsBytes(bytes);
  }
}
