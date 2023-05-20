

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/weather_cubit.dart';
import '../bloc/weather_state.dart';
import 'weather_home.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<WeatherCubit>().fetchForecastWeather("Yangon");


    return Scaffold(
      body: Center(
        child: BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state){
          switch (state.status) {
            case WeatherStatus.initial:
              return Container();
            case WeatherStatus.loading:
              return Center(child: CircularProgressIndicator(),);
            case WeatherStatus.success:
              return WeatherHome(forecastWeather: state.forecastWeather);
            case WeatherStatus.failure:
              return Center(child: Text("Failure"),);
          }
        }, listener: (context, state){}),
      ),
    );
  }
}
