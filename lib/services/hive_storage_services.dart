import 'package:bodygravity/data/local/storage_service.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveStorageService implements StorageService {
  late Box _box;
  @override
  Future<void> init() async {
    // Initialize Hive and open a box
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
     _box = await Hive.openBox('myBox');
  }

  @override
  Future<void> saveData<T>(String key, T value) async {
    await _box.put(key, value);
  }

  @override
  Future<T?> getData<T>(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> deleteData(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}
