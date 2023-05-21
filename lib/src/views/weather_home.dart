import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/bloc/index_cubit.dart';

import '../model/forecast_weather_data_model.dart';
import 'widgets/current_weather_widget.dart';
import 'widgets/forecast_weather_widget.dart';

class WeatherHome extends StatelessWidget {
  final ForecastWeather? forecastWeather;

  const WeatherHome({Key? key, this.forecastWeather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndexCubit, int>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: [
            CurrentWeatherWidget(forecastWeather!),
            const ForecastWeatherWidget()
          ][state],
          bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.transparent,
            onTap: (index) {
              context.read<IndexCubit>().changeIndex(index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
              BottomNavigationBarItem(icon: Icon(Icons.cloud_circle_rounded), label: "Forecast"),
            ],
          ),
        );
      },
    );
  }
}
