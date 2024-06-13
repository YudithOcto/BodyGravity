abstract class StorageService {
  Future<void> init();
  Future<void> saveData<T>(String key, T value);
  Future<T?> getData<T>(String key);
  Future<void> deleteData(String key);
  Future<void> clearAll();
}
