import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../modules/weather/data/models/weather_model.dart';

class HiveDatabase {
  HiveDatabase._();

  static final HiveDatabase _instance = HiveDatabase._();

  factory HiveDatabase() => _instance;

  static String offlineCache = 'offlineCache';
  static String weather = 'weather';
  static String temperatureUnit = 'temperatureUnit';
  Box? cacheBox;

  static Future<void> init() async {
    final path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    _instance.cacheBox = await Hive.openBox(offlineCache);
    log('AppBox Open: ${_instance.cacheBox?.isOpen}');
  }

  static void storeCache(String key, dynamic value) async {
    _instance.cacheBox!.put(key, value);
  }

  static dynamic getCache(String key) {
    return _instance.cacheBox!.get(key);
  }
}
