
import 'package:weather_show/src/bloc/weather_bloc/weather_state.dart';

import '../../model/forecast_weather_data_model.dart';

enum SearchDetailStatus{initial, loading, success, failure}
class SearchDetailState {
  final SearchDetailStatus status;
  // final CurrentWeatherDataModel? currentWeather;
  final ForecastWeather? forecastWeather;
  SearchDetailState({this.status = SearchDetailStatus.initial, this.forecastWeather});

  SearchDetailState copyWith({SearchDetailStatus? status, ForecastWeather? forecastWeather}) {
    return SearchDetailState(status: status ?? this.status, forecastWeather: forecastWeather ?? this.forecastWeather);
  }
}