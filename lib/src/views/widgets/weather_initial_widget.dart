import 'package:flutter/material.dart';

class WeatherInitialWidget extends StatelessWidget {
  const WeatherInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return const Center(
      child: Text('🏙️', style: TextStyle(fontSize: 64)),
    );
  }
}