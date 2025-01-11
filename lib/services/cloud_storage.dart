import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CloudStorage {
  late final FirebaseStorage _storage;

  CloudStorage() {
    _initialize();
  }

  void _initialize() {
    _storage = FirebaseStorage.instance;
  }

  // Шлях до папки для збереження файлів у Firebase Storage
  final String _folderPath = "database_backups";

  // Завантаження нової копії бази даних
  Future<void> uploadDatabase(String localFilePath) async {
    try {
      final fileName = _generateFileName();
      final ref = _storage.ref().child("$_folderPath/$fileName");

      // Завантаження файлу з метаданими
      await ref.putFile(
        File(localFilePath),
        SettableMetadata(customMetadata: {
          'uploadDate': DateTime.now().toIso8601String(),
        }),
      );
      Fluttertoast.showToast(msg: "Завантажено!");
    } catch (e) {
      Fluttertoast.showToast(msg: "ПОМИЛКА!");
    }
  }

  // Автоматичне видалення файлів, старших за місяць
  Future<void> deleteOldFiles() async {
    try {
      final ListResult result =
          await _storage.ref().child(_folderPath).listAll();
      final now = DateTime.now();

      for (final Reference fileRef in result.items) {
        final FullMetadata metadata = await fileRef.getMetadata();
        final uploadDateStr = metadata.customMetadata?['uploadDate'];

        if (uploadDateStr != null) {
          final uploadDate = DateTime.parse(uploadDateStr);
          if (now.difference(uploadDate).inDays > 14) {
            await fileRef.delete();
            print(
                "Файл ${fileRef.name} видалено, оскільки він старіший за місяць.");
          }
        } else {
          print("Файл ${fileRef.name} не має метаданих uploadDate, пропущено.");
        }
      }
    } catch (e) {
      print("Помилка під час видалення старих файлів: $e");
    }
  }

  // Генерація унікального імені файлу для бази даних
  String _generateFileName() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd_HH-mm-ss');
    return "db_backup_${formatter.format(now)}.sqlite";
  }
}
