import 'package:flutter/material.dart';

class WeatherFailWidget extends StatelessWidget {
  final Function? tryAgain;

  const WeatherFailWidget({super.key, this.tryAgain});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🙈', style: TextStyle(fontSize: 64)),
          Text(
            'Something went wrong!',
            style: theme.textTheme.headlineSmall,
          ),
          TextButton(
            onPressed: () {
              tryAgain?.call();
            },
            child: const Text("Try Again"),
          )
        ],
      ),
    );
  }
}
