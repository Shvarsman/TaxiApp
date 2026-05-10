import 'package:flutter/material.dart';

class AnimatedMarker extends StatefulWidget {
  const AnimatedMarker({super.key});

  @override
  State<AnimatedMarker> createState() => _AnimatedMarkerState();
}

class _AnimatedMarkerState extends State<AnimatedMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,        // теперь правильное имя параметра
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -5 * _controller.value),
          child: const Icon(Icons.local_taxi, size: 30, color: Colors.yellow),
        );
      },
    );
  }
}