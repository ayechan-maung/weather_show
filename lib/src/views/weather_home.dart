import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/bloc/index_cubit.dart';

import '../model/forecast_weather_data_model.dart';
import 'widgets/current_weather_widget.dart';
import 'widgets/forecast_weather_widget.dart';

class WeatherHome extends StatelessWidget {
  final ForecastWeatherDataModel? forecastWeather;

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
            ForecastWeatherWidget(forecastWeather!.forecast!)
          ][state],
          bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.transparent,
            onDestinationSelected: (int index) {
              context.read<IndexCubit>().changeIndex(index);
            },
            selectedIndex: state,
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(Icons.today),
                icon: Icon(Icons.today_rounded),
                label: 'Today',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.favorite),
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorite',
              ),

            ],
          ),
        );
          // bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.transparent,
          //   onTap: (index) {
          //     context.read<IndexCubit>().changeIndex(index);
          //   },
          //   items: const [
          //     BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          //     BottomNavigationBarItem(icon: Icon(Icons.cloud_circle_rounded), label: "Forecast"),
          //   ],
          // ),
        // );
      },
    );
  }
}
