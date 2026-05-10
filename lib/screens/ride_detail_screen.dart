// lib/screens/ride_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:taxi_app/models/ride.dart';
import 'package:taxi_app/services/hive_cache_service.dart'; // для загрузки по ID

class RideDetailScreen extends StatelessWidget {
  final int rideId;
  const RideDetailScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    // Загружаем поездку из кэша / сервиса (в реальном проекте — через BLoC).
    // Для примера используем заглушку.
    return FutureBuilder<Ride?>(
      future: _fetchRide(rideId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final ride = snapshot.data;
        if (ride == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Поездка не найдена')),
            body: const Center(child: Text('Нет данных')),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text('${ride.fromLocation} → ${ride.toLocation}')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Тариф: ${ride.tariff}', style: const TextStyle(fontSize: 18)),
                Text('Цена: \$${ride.price}', style: const TextStyle(fontSize: 18)),
                Text('Водитель: ${ride.driver}', style: const TextStyle(fontSize: 18)),
                Text('Дата: ${ride.timestamp}', style: const TextStyle(fontSize: 18)),
                if (ride.rating != null)
                  Row(children: List.generate(5, (i) => Icon(i < ride.rating! ? Icons.star : Icons.star_border))),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Ride?> _fetchRide(int id) async {
    // Заглушка: берём из кэша (HiveCacheService)
    // В реальном проекте — через HistoryBloc или репозиторий.
    final cache = HiveCacheService();
    final cachedRides = cache.getCachedRides();
    if (cachedRides != null) {
      for (final r in cachedRides) {
        final ride = Ride.fromMap(Map<String, dynamic>.from(r));
        if (ride.id == id) return ride;
      }
    }
    return null;
  }
}