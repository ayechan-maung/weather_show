import 'package:flutter/material.dart';

class WeatherInitialWidget extends StatelessWidget {
  const WeatherInitialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏙️', style: TextStyle(fontSize: 64)),
          Text(
            'Please Select a City!',
            style: theme.textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}