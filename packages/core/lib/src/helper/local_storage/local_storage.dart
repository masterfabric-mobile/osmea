
part of 'local_storage_helper.dart';

// Abstract class defining the interface for LocalStorage operations
abstract class LocalStorage {
  Future<void> init();
  // Regular items
  Future<void> setItem(String key, dynamic value);
  Future<dynamic> getItem(String key);
  Future<void> removeItem(String key);
  Future<void> clear();
  Future<Map<String, dynamic>> getAllItems();
  Future<void> close();
  // Encrypted items
  Future<void> setEncryptedItem(String key, String value);
  Future<String?> getEncryptedItem(String key);
  Future<Map<String, String>> getEncryptedItems();
}