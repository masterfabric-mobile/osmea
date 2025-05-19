library local_storage_helper;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'dart:convert'; // For Base64 encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences

part 'local_storage.dart';

class LocalStorageHelper implements LocalStorage {
  // Singleton instance
  static final LocalStorageHelper _instance = LocalStorageHelper._internal();

  // Private constructor
  LocalStorageHelper._internal();

  // Factory constructor
  factory LocalStorageHelper() {
    return _instance;
  }

  // Database instance for sqflite
  Database? _database;
  // SharedPreferences instance for web
  SharedPreferences? _sharedPreferences;

  // A simple encryption key
  final String _encryptionKey = 'osmea_secure_storage_key';

  // Initialization method
  @override
  Future<void> init() async {
    debugPrint("🔄 Initializing LocalStorageHelper...");

    if (kIsWeb) {
      // Initialize SharedPreferences for web
      _sharedPreferences = await SharedPreferences.getInstance();
      debugPrint("✅ SharedPreferences initialized successfully.");
      debugPrint("🌐 Platform detected: Web. SharedPreferences loaded.");
    } else {
      // Get the database path for sqflite
      var databasesPath = await getDatabasesPath();
      debugPrint("📁 Database path retrieved: $databasesPath");
      String path = join(databasesPath, 'local_storage_osmea_core.db');
      debugPrint("📍 Full database path: $path");

      // Open the database
      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        debugPrint("🛠️ Creating storage table...");
        await db.execute('''
          CREATE TABLE IF NOT EXISTS storage (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
        debugPrint("✅ Storage table created successfully.");
      });
      debugPrint("✅ LocalStorageHelper initialized successfully.");
      debugPrint("📱 Platform detected: Mobile. SQLite database loaded.");
    }
  }

  // Save a key-value pair with dynamic value
  @override
  Future<void> setItem(String key, dynamic value) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      if (value is String) {
        await _sharedPreferences!.setString(key, value);
      } else if (value is bool) {
        await _sharedPreferences!.setBool(key, value);
      } else if (value is int) {
        await _sharedPreferences!.setInt(key, value);
      }
      debugPrint("Item set successfully in SharedPreferences: $key");
    } else {
      if (_database == null) {
        throw Exception("Database not initialized. Call init() first.");
      }
      debugPrint("Setting item in sqflite: $key");
      await _database!.insert(
        'storage',
        {'key': key, 'value': value.toString()}, // Store as string
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("Item set successfully in sqflite: $key");
    }
  }

  // Retrieve a value with dynamic return type
  @override
  Future<dynamic> getItem(String key) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      return _sharedPreferences!.get(key);
    } else {
      if (_database == null) {
        throw Exception("Database not initialized. Call init() first.");
      }
      debugPrint("Getting item from sqflite: $key");
      List<Map<String, dynamic>> maps = await _database!.query(
        'storage',
        columns: ['value'],
        where: 'key = ?',
        whereArgs: [key],
      );
      if (maps.isNotEmpty) {
        debugPrint("Item retrieved successfully from sqflite: $key");
        return maps.first['value']; // Return as string
      }
      debugPrint("Item not found in sqflite: $key");
      return null;
    }
  }

  // Remove an item
  @override
  Future<void> removeItem(String key) async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      await _sharedPreferences!.remove(key);
      debugPrint("Item removed successfully from SharedPreferences: $key");
    } else {
      if (_database == null) {
        throw Exception("Database not initialized. Call init() first.");
      }
      debugPrint("Removing item from sqflite: $key");
      await _database!.delete(
        'storage',
        where: 'key = ?',
        whereArgs: [key],
      );
      debugPrint("Item removed successfully from sqflite: $key");
    }
  }

  // Clear all items
  @override
  Future<void> clear() async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      await _sharedPreferences!.clear();
      debugPrint("All items cleared from SharedPreferences.");
    } else {
      if (_database == null) {
        throw Exception("Database not initialized. Call init() first.");
      }
      debugPrint("Clearing all items from sqflite.");
      await _database!.delete('storage');
      debugPrint("All items cleared successfully from sqflite.");
    }
  }

  // Retrieve all items
  @override
  Future<Map<String, dynamic>> getAllItems() async {
    if (kIsWeb) {
      // Use SharedPreferences for web
      final Map<String, dynamic> items = {};
      for (String key in _sharedPreferences!.getKeys()) {
        items[key] = _sharedPreferences!.get(key); // Get the value directly
      }
      debugPrint("All items retrieved successfully from SharedPreferences.");
      return items;
    } else {
      if (_database == null) {
        throw Exception("Database not initialized. Call init() first.");
      }
      debugPrint("Getting all items from sqflite.");
      List<Map<String, dynamic>> maps = await _database!.query('storage');
      final Map<String, dynamic> items = {};
      for (var map in maps) {
        String key = map['key'] as String;
        String value = map['value'] as String;

        // Determine the type of the value
        if (value == 'true' || value == 'false') {
          items[key] = value == 'true'; // Convert to bool
        } else if (int.tryParse(value) != null) {
          items[key] = int.parse(value); // Convert to int
        } else {
          items[key] = value; // Keep as string
        }
      }
      debugPrint("All items retrieved successfully from sqflite.");
      return items;
    }
  }

  // Close the database
  @override
  Future<void> close() async {
    if (kIsWeb) {
      // No need to close SharedPreferences
      debugPrint("SharedPreferences does not need to be closed.");
    } else {
      if (_database != null) {
        debugPrint("Closing database.");
        await _database!.close();
        debugPrint("Database closed successfully.");
      }
    }
  }

  // Encrypt a string value - proper reversible encryption
  String encrypt(String value) {
    try {
      // Simple XOR-based encryption with base64 encoding
      final List<int> valueBytes = utf8.encode(value);
      final List<int> keyBytes = utf8.encode(_encryptionKey);
      final List<int> encrypted = [];

      for (var i = 0; i < valueBytes.length; i++) {
        final keyChar = keyBytes[i % keyBytes.length];
        encrypted.add(valueBytes[i] ^ keyChar);
      }

      return base64.encode(encrypted);
    } catch (e) {
      debugPrint("Error during encryption: $e");
      // If encryption fails, return a base64 encoded version of the original
      return base64.encode(utf8.encode(value));
    }
  }

  // Decrypt an encrypted string value
  String decrypt(String encryptedValue) {
    try {
      // Reverse the XOR encryption
      final List<int> encrypted = base64.decode(encryptedValue);
      final List<int> keyBytes = utf8.encode(_encryptionKey);
      final List<int> decrypted = [];

      for (var i = 0; i < encrypted.length; i++) {
        final keyChar = keyBytes[i % keyBytes.length];
        decrypted.add(encrypted[i] ^ keyChar);
      }

      return utf8.decode(decrypted);
    } catch (e) {
      debugPrint("Error during decryption: $e");
      // If decryption fails, try to return the input as is
      try {
        return utf8.decode(base64.decode(encryptedValue));
      } catch (_) {
        return "Decryption failed";
      }
    }
  }

  // Save an encrypted value with a prefixed key
  @override
  Future<void> setEncryptedItem(String key, String value) async {
    final encryptedValue = encrypt(value);
    await setItem('osmeaEncrypted_$key', encryptedValue); // Add prefix to the key
  }

  // Retrieve and decrypt a value using the prefixed key
  @override
  Future<String?> getEncryptedItem(String key) async {
    final encryptedValue = await getItem('osmeaEncrypted_$key'); // Add prefix to the key
    if (encryptedValue != null) {
      return decrypt(encryptedValue);
    }
    return null;
  }

  // Retrieve all encrypted items with prefixed keys
  @override
  Future<Map<String, String>> getEncryptedItems() async {
    debugPrint("Retrieving all encrypted items...");
    final allItems = await getAllItems();
    final Map<String, String> decryptedItems = {};

    for (var entry in allItems.entries) {
      if (entry.key.startsWith('osmeaEncrypted_')) { // Check for prefixed keys
        try {
          final decryptedValue = decrypt(entry.value);
          decryptedItems[entry.key] = decryptedValue;
        } catch (e) {
          debugPrint("Error decrypting item ${entry.key}: $e");
          // Skip items that can't be decrypted
          continue;
        }
      }
    }

    debugPrint("All encrypted items retrieved and decrypted successfully.");
    return decryptedItems;
  }
}
