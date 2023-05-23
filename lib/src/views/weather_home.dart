import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/auth/auth_gate.dart';
import 'package:weather_show/src/bloc/index_cubit.dart';

import '../model/forecast_weather_data_model.dart';
import 'widgets/current_weather_widget.dart';
import 'widgets/fav_weather_widget.dart';
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
            ForecastWeatherWidget(forecastDays: forecastWeather!.forecast!.forecastday!),
            const FavoriteWeatherWidget(),
            const AuthGate(),
          ][state],
          bottomNavigationBar: NavigationBar(surfaceTintColor: Colors.white,
            backgroundColor: Colors.transparent,
            onDestinationSelected: (int index) {
              context.read<IndexCubit>().changeIndex(index);
            },
            selectedIndex: state,
            animationDuration: Duration(milliseconds: 200),
            destinations: const <NavigationDestination>[
              NavigationDestination(
                selectedIcon: Icon(Icons.today),
                icon: Icon(Icons.today_rounded),
                label: 'Today',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.cloud_circle_rounded),
                icon: Icon(Icons.cloud_circle_outlined),
                label: 'Forecast',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.favorite),
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorite',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person),
                icon: Icon(Icons.person_outline_rounded),
                label: 'Admin',
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
