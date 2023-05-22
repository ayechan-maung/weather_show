

import 'package:floor/floor.dart';

import '../entity/weather_entity.dart';

abstract class LocationDao {
  @insert
  Future<ForecastWeather> addWeather(ForecastWeather location);

  @Query("SELECT * FROM Location")
  Future<List<ForecastWeather>> allLocation();
}