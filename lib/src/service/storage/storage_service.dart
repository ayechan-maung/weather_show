import 'package:sqflite/sqflite.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';

abstract class StorageService {

  Future<Database> initDataBase(String path);

  Future onCreate(Database db, int version);

  Future<ForecastWeather> addCityWeather(ForecastWeather city);

  Future<int> updateCityWeather(int id);

  Future<ForecastWeather> getCityWeather(int id);

  Future<List<ForecastWeather>> getAllWeather();

  Future<int> deleteWeather(int id);

  Future<void> close();
}