import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveDatabase {
  HiveDatabase._();

  static final HiveDatabase _instance = HiveDatabase._();

  factory HiveDatabase() => _instance;

  static String offlineCache = 'offlineCache';
  static String weather = 'weather';
  static String temperatureUnit = 'temperatureUnit';
  Box? cacheBox;

  // Initialize Hive and open the box
  static Future<void> init() async {
    try {
      // Get the application documents directory
      final path = await getApplicationDocumentsDirectory();

      // Initialize Hive with the specified directory path
      Hive.init(path.path);

      // Open the Hive box for caching
      _instance.cacheBox = await Hive.openBox(offlineCache);

      // Log whether the box is open (for debugging purposes)
      log('AppBox Open: ${_instance.cacheBox?.isOpen}');
    } catch (e) {
      // If an error occurs during initialization
      log('Error initializing Hive database: $e');
    }
  }

  // Store data in the Hive box
  static void storeCache(String key, dynamic value) async {
    _instance.cacheBox!.put(key, value);
  }

  // Retrieve data from the Hive box
  static dynamic getCache(String key) {
    return _instance.cacheBox!.get(key);
  }

  // Close the Hive box when it's no longer needed
  static void close() {
    _instance.cacheBox?.close();
  }
}
