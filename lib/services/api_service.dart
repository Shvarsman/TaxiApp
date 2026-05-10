import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.openweathermap.org/data/2.5'));
  final String apiKey = 'ca48ac33cfd400962c55723280ee177a';

  Future<Map<String, dynamic>> fetchWeather(double lat, double lon) async {
    final response = await _dio.get('/weather', queryParameters: {
      'lat': lat,
      'lon': lon,
      'appid': apiKey,
      'units': 'metric',
      'lang': 'ru',
    });
    return response.data;
  }
}