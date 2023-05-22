
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_show/src/bloc/search_detail_state.dart';

import '../repository/http_weather_repository.dart';
import 'weather_state.dart';

class SearchDetailCubit extends Cubit<SearchDetailState> {
  SearchDetailCubit(this.weatherRepository) : super(SearchDetailState());
  final HttpWeatherRepository weatherRepository;

  Future<void> getWeatherDetail(String? city) async {
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
