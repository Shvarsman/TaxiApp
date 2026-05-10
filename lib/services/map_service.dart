import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  // Симулированный маршрут (Минск – центр) – координаты в LatLng Google Maps
  final List<LatLng> _route = const [
    LatLng(53.9045, 27.5615),
    LatLng(53.9050, 27.5660),
    LatLng(53.9058, 27.5700),
    LatLng(53.9065, 27.5740),
    LatLng(53.9070, 27.5770),
    LatLng(53.9080, 27.5800),
    LatLng(53.9090, 27.5830),
    LatLng(53.9100, 27.5860),
    LatLng(53.9110, 27.5890),
    LatLng(53.9120, 27.5920),
  ];

  Stream<LatLng> simulateDriverMovement() async* {
    for (final point in _route) {
      await Future.delayed(const Duration(seconds: 1));
      yield point;
    }
  }

  LatLng get startPoint => _route.first;
  LatLng get endPoint => _route.last;
}