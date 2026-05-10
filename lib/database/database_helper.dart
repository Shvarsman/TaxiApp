import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_app/models/ride.dart';

/// Сервис для работы с локальной базой данных (Hive).
/// Позволяет выполнять CRUD-операции с поездками.
class DatabaseHelper {
  final Box _box;

  DatabaseHelper(this._box);

  /// Инициализация бокса – вызывается один раз в main.dart
  static Future<Box> initBox() async {
    return await Hive.openBox('rides');
  }

  /// Получить все поездки, отсортированные по дате (новые сверху)
  List<Ride> getAllRides() {
    try {
      final List<dynamic>? rawList = _box.get('ride_list');
      if (rawList == null) return [];
      return rawList
          .map((e) => Ride.fromMap(Map<String, dynamic>.from(e)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('DatabaseHelper getAllRides error: $e');
      return [];
    }
  }

  /// Добавить новую поездку и автоматически присвоить ей id
  Future<int> insertRide(Ride ride) async {
    try {
      final rides = getAllRides();
      final newId = rides.isEmpty ? 1 : rides.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      final rideWithId = ride.copyWith(id: newId);
      rides.add(rideWithId);
      await _saveRides(rides);
      return newId;
    } catch (e) {
      debugPrint('DatabaseHelper insertRide error: $e');
      rethrow;
    }
  }

  /// Получить поездку по id
  Ride? getRideById(int id) {
    try {
      return getAllRides().where((r) => r.id == id).firstOrNull;
    } catch (e) {
      debugPrint('DatabaseHelper getRideById error: $e');
      return null;
    }
  }

  /// Обновить рейтинг поездки
  Future<void> updateRating(int rideId, int rating) async {
    try {
      final rides = getAllRides();
      final index = rides.indexWhere((r) => r.id == rideId);
      if (index != -1) {
        rides[index] = rides[index].copyWith(rating: rating);
        await _saveRides(rides);
      }
    } catch (e) {
      debugPrint('DatabaseHelper updateRating error: $e');
      rethrow;
    }
  }

  /// Удалить поездку по id
  Future<void> deleteRide(int rideId) async {
    try {
      final rides = getAllRides();
      rides.removeWhere((r) => r.id == rideId);
      await _saveRides(rides);
    } catch (e) {
      debugPrint('DatabaseHelper deleteRide error: $e');
      rethrow;
    }
  }

  /// Очистить все поездки (например, при очистке кеша)
  Future<void> clearAll() async {
    try {
      await _box.delete('ride_list');
    } catch (e) {
      debugPrint('DatabaseHelper clearAll error: $e');
    }
  }

  // Внутренний метод для сохранения списка в бокс
  Future<void> _saveRides(List<Ride> rides) async {
    await _box.put('ride_list', rides.map((r) => r.toMap()).toList());
  }
}