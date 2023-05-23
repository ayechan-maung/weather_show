import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/service/storage/storage_service.dart';

class FavCityStorage implements StorageService {
  static final FavCityStorage instance = FavCityStorage._init();

  FavCityStorage._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDataBase("cities.db");
    return _database!;
  }

  @override
  Future<ForecastWeather> addCityWeather(ForecastWeather city) async {
    final location = city.location;
    final currentL = city.current;

    final db = await instance.database;
    await db.transaction((txn) async {
      final locationId = await txn.insert("locations",location!.toJson()
          ); //{'is_favorite': city.location!.isFavorite! ? 1: 0, ...}
      await txn.insert("current_weather", {'location_id': locationId, ...currentL!.toJson()});
      debugPrint("Current Json :: ${currentL.toJson()}");
    });

    return city;
  }

  @override
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  @override
  Future<int> deleteWeather(int id) async {
    final db = await instance.database;
    return db.delete("locations", where: 'id =?', whereArgs: [id]);
  }

  @override
  Future<List<ForecastWeather>> getAllWeather() async {
    final db = await instance.database;
    final result = await db.query("locations");
    // return result;
    final List<ForecastWeather> weathers = [];

    for (final weather in result) {
      final locationId = weather['id'] as int;
      print("location id $locationId");
      final currentWeather =
          await db.query('current_weather', where: 'location_id =?', whereArgs: [locationId]);
      // final currentCondition = await db.query(tableCondition, where: 'location_id =?', whereArgs: [locationId]);

      final weatherData = ForecastWeather(
        location: Location.fromJson(weather),
        current: currentWeather.isNotEmpty ? Current.fromJson(currentWeather.first) : null,
      );
      weathers.add(weatherData);
    }
    //
    // // close();

    return weathers;
    // return result.map((e) => ForecastWeather.fromJson(e)).toList();
  }

  @override
  Future<ForecastWeather> getCityWeather(int id) async {
    final db = await instance.database;
    final results =
        await db.query('locations', columns: Location.column, where: 'id =?', whereArgs: [id]);
    Current? currentWeather;
    if (results.isNotEmpty) {
      for (var location in results) {
        final locationId = location['id'] as int?;
        final cWeather =
            await db.query('current_weather', where: 'location_id =?', whereArgs: [locationId]);
        debugPrint("Result in DB $cWeather");

        if (cWeather.isNotEmpty) {
          currentWeather = Current.fromJson(cWeather.first);
        }
      }
      // await close();
      return ForecastWeather(location: Location.fromJson(results.first), current: currentWeather);
    } else {
      throw Exception("$id not found");
    }
  }

  @override
  Future<Database> initDataBase(String path) async {
    var databasePath = await getDatabasesPath();
    String filePath = join(databasePath, path);
    return await openDatabase(filePath, version: 1, onCreate: onCreate);
  }

  @override
  Future onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            is_favorite INTEGER,
            name TEXT,
            region TEXT,
            country TEXT,
            lat REAL,
            lon REAL,
            tz_id TEXT,
            localtime_epoch INTEGER,
            localtime TEXT
          )
        ''');

    await db.execute('''
          CREATE TABLE current_weather (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            location_id INTEGER,
            last_updated_epoch INTEGER,
            last_updated TEXT,
            temp_c REAL,
            temp_f REAL,
            is_day INTEGER,
            condition_text TEXT,
            condition_code INTEGER,
            wind_mph REAL,
            wind_kph REAL,
            wind_degree INTEGER,
            wind_dir TEXT,
            pressure_mb REAL,
            pressure_in REAL,
            humidity INTEGER,
            cloud INTEGER,
            feelslike_c REAL,
            feelslike_f REAL,
            vis_km REAL,
            vis_miles REAL,
            uv REAL,
            FOREIGN KEY (location_id) REFERENCES locations (id)
          )
        ''');
  }

  @override
  Future<int> updateCityWeather(Location id) async {
    final db = await instance.database;
    return db.update("locations", id.toJson(), whereArgs: [id.id], where: 'id =?');
  }
}

