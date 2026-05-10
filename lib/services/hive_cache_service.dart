import 'package:hive_flutter/hive_flutter.dart';

class HiveCacheService {
  final Box _box = Hive.box('cache');

  void cacheRides(List<dynamic> rides) => _box.put('rides', rides);
  List<dynamic>? getCachedRides() => _box.get('rides');

  void cacheWeather(dynamic weather) => _box.put('weather', weather);
  dynamic getCachedWeather() => _box.get('weather');

  Future<void> clearCache() async {
    await _box.delete('rides');
    await _box.delete('weather');
  }
}