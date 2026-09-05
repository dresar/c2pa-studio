import 'dart:typed_data';
import 'file_saver_stub.dart'
    if (dart.library.html) 'file_saver_web.dart'
    if (dart.library.io) 'file_saver_desktop.dart' as saver;

Future<void> saveFileBytes(Uint8List bytes, String filename) async {
  await saver.saveFileBytes(bytes, filename);
}
