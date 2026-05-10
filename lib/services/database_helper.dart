// lib/services/database_helper.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taxi_app/models/ride.dart';

/// Класс для локального хранения поездок с использованием Hive.
/// В качестве хранилища используется переданный Box.
class DatabaseHelper {
  final Box _box;

  DatabaseHelper(this._box);

  /// Возвращает список всех поездок, отсортированный по дате (новые сверху).
  List<Ride> getAllRides() {
    try {
      final List? rawList = _box.get('ride_list');
      if (rawList == null) return [];
      final rides = rawList
          .map((e) => Ride.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      rides.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return rides;
    } catch (e) {
      debugPrint('DatabaseHelper.getAllRides error: $e');
      return [];
    }
  }

  /// Добавляет новую поездку и автоматически присваивает ей id.
  /// Возвращает присвоенный id.
  Future<int> insertRide(Ride ride) async {
    try {
      final rides = getAllRides();
      final newId = rides.isEmpty
          ? 1
          : rides.map((r) => r.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      final rideWithId = ride.copyWith(id: newId);
      rides.add(rideWithId);
      await _saveRides(rides);
      return newId;
    } catch (e) {
      debugPrint('DatabaseHelper.insertRide error: $e');
      rethrow;
    }
  }

  /// Возвращает поездку по идентификатору, либо null.
  Ride? getRideById(int id) {
    try {
      return getAllRides().where((r) => r.id == id).firstOrNull;
    } catch (e) {
      debugPrint('DatabaseHelper.getRideById error: $e');
      return null;
    }
  }

  /// Обновляет рейтинг поездки.
  Future<void> updateRating(int rideId, int rating) async {
    try {
      final rides = getAllRides();
      final index = rides.indexWhere((r) => r.id == rideId);
      if (index != -1) {
        rides[index] = rides[index].copyWith(rating: rating);
        await _saveRides(rides);
      }
    } catch (e) {
      debugPrint('DatabaseHelper.updateRating error: $e');
      rethrow;
    }
  }

  /// Удаляет поездку по идентификатору.
  Future<void> deleteRide(int rideId) async {
    try {
      final rides = getAllRides();
      rides.removeWhere((r) => r.id == rideId);
      await _saveRides(rides);
    } catch (e) {
      debugPrint('DatabaseHelper.deleteRide error: $e');
      rethrow;
    }
  }

  /// Очищает все сохранённые поездки.
  Future<void> clearAll() async {
    try {
      await _box.delete('ride_list');
    } catch (e) {
      debugPrint('DatabaseHelper.clearAll error: $e');
    }
  }

  // Внутренний метод сохранения списка в Hive.
  Future<void> _saveRides(List<Ride> rides) async {
    final data = rides.map((r) => r.toMap()).toList();
    await _box.put('ride_list', data);
  }
}