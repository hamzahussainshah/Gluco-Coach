import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../ui/widgets/custom_logger/custom_logger.dart';

class LocalStorageService {
  final log = CustomLogger(className: 'Local Storage Service');
  static const String fileName = 'local_storage.json';
  static const String currentUserIDKey = 'currentUserID';
  static const String isLogedInKey = 'isLoggedIn';
  static const String nameUser = 'userName';
  static const String emailKey = 'email';
  static const String lastExerciseLogDateKey =
      'lastExerciseLogDate'; // New key for last logged exercise date

  late File _localFile;
  Map<String, dynamic> _data = {};

  /// Initializes the local storage by loading data from the JSON file
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _localFile = File('${directory.path}/$fileName');

    if (await _localFile.exists()) {
      try {
        final contents = await _localFile.readAsString();

        // **Ensure JSON is valid**
        if (contents.trim().isNotEmpty && contents.trim().startsWith('{')) {
          _data = jsonDecode(contents);
        } else {
          log.d("Invalid JSON detected. Resetting storage.");
          await resetStorage();
        }

        log.d('Loaded data: $_data');
      } catch (e) {
        log.d("Error reading storage file: $e. Resetting storage.");
        await resetStorage();
      }
    } else {
      await resetStorage();
    }
  }

  /// **Resets the storage file completely**
  Future<void> resetStorage() async {
    _data = {};
    await _writeToFile();
    log.d("Storage reset complete.");
  }

  // Getters and setters for currentUserID
  String? get currentUserID => _getFromDisk(currentUserIDKey);
  set currentUserID(String? userId) => _saveToDisk(currentUserIDKey, userId);

  // Getters and setters for isLogedIn
  bool get isLogedIn => _getFromDisk(isLogedInKey) ?? false;
  set isLogedIn(bool value) => _saveToDisk(isLogedInKey, value);

  // Getters and setters for userName
  String? get userName => _getFromDisk(nameUser);
  set userName(String? name) => _saveToDisk(nameUser, name);

  // Getters and setters for email
  String? get email => _getFromDisk(emailKey);
  set email(String? emailValue) => _saveToDisk(emailKey, emailValue);

  // Getters and setters for lastExerciseLogDate
  DateTime? get lastExerciseLogDate {
    final value = _getFromDisk(lastExerciseLogDateKey);
    if (value != null) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  set lastExerciseLogDate(DateTime? date) {
    if (date != null) {
      _saveToDisk(lastExerciseLogDateKey, date.toIso8601String());
    } else {
      _saveToDisk(lastExerciseLogDateKey, null);
    }
  }

  /// Gets the value of a key from the data map
  T? _getFromDisk<T>(String key) {
    final value = _data[key] as T?;
    log.d('Getting key: $key, value: $value');
    return value;
  }

  /// Saves the value to the data map and writes the JSON file
  Future<void> _saveToDisk<T>(String key, T? content) async {
    log.d('Saving key: $key, value: $content');

    if (content == null) {
      _data.remove(key);
    } else {
      _data[key] = content;
    }

    await _writeToFile();
  }

  /// Writes the current _data map to the JSON file
  Future<void> _writeToFile() async {
    try {
      final jsonString = jsonEncode(_data);
      final tempFile = File('${_localFile.path}.tmp'); // Temporary file

      // **Write data to a temp file first to prevent corruption**
      await tempFile.writeAsString(jsonString);

      // **Rename temp file to actual file (atomic operation)**
      await tempFile.rename(_localFile.path);

      log.d('Data written successfully: $jsonString');
    } catch (e) {
      log.d("Error writing storage file: $e");
    }
  }
}
