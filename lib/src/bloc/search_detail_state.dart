
import 'package:weather_show/src/bloc/weather_state.dart';

import '../model/forecast_weather_data_model.dart';

class SearchDetailState {
  final WeatherStatus status;
  // final CurrentWeatherDataModel? currentWeather;
  final ForecastWeather? forecastWeather;
  SearchDetailState({this.status = WeatherStatus.initial, this.forecastWeather});

  SearchDetailState copyWith({WeatherStatus? status, ForecastWeather? forecastWeather}) {
    return SearchDetailState(status: status ?? this.status, forecastWeather: forecastWeather ?? this.forecastWeather);
  }
}