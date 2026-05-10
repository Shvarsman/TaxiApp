import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Weather {
  final double temp;
  final String description;
  final String icon;

  Weather({required this.temp, required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
    );
  }
}

class WeatherService {
  final String apiKey = 'ca48ac33cfd400962c55723280ee177a';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(double lat, double lon) async {
    try {
      final uri = Uri.parse(
        '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=ru',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return Weather.fromJson(json.decode(response.body));
      } else {
        debugPrint('Weather API error ${response.statusCode}: ${response.body}');
        throw Exception('Weather API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Weather fetch error: $e');
      rethrow;
    }
  }
}