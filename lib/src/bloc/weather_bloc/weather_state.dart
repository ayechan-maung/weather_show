import '../../model/current_weather_data_model.dart';
import '../../model/forecast_weather_data_model.dart';

enum WeatherStatus { initial, loading, success, failure }

class WeatherState {
  final WeatherStatus status;
  // final CurrentWeatherDataModel? currentWeather;
  final ForecastWeather? forecastWeather;
  WeatherState({this.status = WeatherStatus.initial, this.forecastWeather});

  WeatherState copyWith({WeatherStatus? status, ForecastWeather? forecastWeather}) {
    return WeatherState(status: status ?? this.status, forecastWeather: forecastWeather ?? this.forecastWeather);
  }
}

extension WeatherStatusEx on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}
