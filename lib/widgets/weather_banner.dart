import 'package:flutter/material.dart';

class WeatherBanner extends StatelessWidget {
  final String weather;
  const WeatherBanner({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.cloud, size: 30),
            const SizedBox(width: 10),
            Text(weather, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}