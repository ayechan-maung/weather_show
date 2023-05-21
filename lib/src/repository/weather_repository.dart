
import '../model/current_weather_data_model.dart';
import '../model/forecast_weather_data_model.dart';

abstract class WeatherRepository {
  Future<CurrentWeatherDataModel> getCurrentWeather(
      {required String endPoint, required String? city});

  Future<ForecastWeather> getForecastWeather(String? city);
}
