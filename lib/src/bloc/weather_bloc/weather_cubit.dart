import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/service/http/dio_http_service.dart';

import '../../repository/http_weather_repository.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this.weatherRepository) : super(WeatherState());
  final HttpWeatherRepository weatherRepository;

  //
  // Future<void> fetchCurrentWeather(
  //     {required String endPoint, required String? city}) async {
  //   emit(state.copyWith(status: WeatherStatus.loading));
  //
  //   try {
  //     final weather = await weatherRepository.getCurrentWeather(endPoint: endPoint, city: city);
  //
  //     debugPrint("Weather :: $weather");
  //
  //     emit(state.copyWith(status: WeatherStatus.success, currentWeather: weather));
  //   } on Exception {
  //     emit(state.copyWith(status: WeatherStatus.failure));
  //   }
  // }

  Future<void> fetchForecastWeather(String? city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final weather = await weatherRepository.getForecastWeather(city);

      debugPrint("Weather :: $weather");

      emit(state.copyWith(status: WeatherStatus.success, forecastWeather: weather));
    } on Exception {
      emit(state.copyWith(status: WeatherStatus.failure));
    }
  }
}
