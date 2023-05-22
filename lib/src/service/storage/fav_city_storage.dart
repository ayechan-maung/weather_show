import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';
import 'package:weather_show/src/service/storage/storage_service.dart';

const String tableLocation = "location";
const String tableCurrent = "current";
const String tableCondition = "condition";

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
      final locationId = await txn.insert("locations", location!.toJson());
      await txn.insert("current_weather", {'location_id': locationId, ...currentL!.toJson()});
    });

    return city;
  }

  @override
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  @override
  Future<int> deleteWeather(int id) async{
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
  Future<ForecastWeather> getCityWeather(int id) async{
    final db = await instance.database;
    final results = await db.query('locations',columns: Location.column, where: 'id =?', whereArgs: [id]);
    if(results.isNotEmpty) {
      return ForecastWeather.fromJson(results.first);
    }else{
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
  Future<int> updateCityWeather(Location id) async{
    final db = await instance.database;
    return db.update("locations", id.toJson(),whereArgs: [id.id], where: 'id =?');
  }
}

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final databasePath = join(dbPath, 'weather_database.db');

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations (
            id INTEGER PRIMARY KEY,
            name TEXT,
            region TEXT,
            country TEXT,
            latitude REAL,
            longitude REAL,
            tz_id TEXT,
            localtime_epoch INTEGER,
            localtime TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE current_weather (
            id INTEGER PRIMARY KEY,
            location_id INTEGER,
            last_updated_epoch INTEGER,
            last_updated TEXT,
            temp_c REAL,
            temp_f REAL,
            is_day INTEGER,
            condition_text TEXT,
            condition_icon TEXT,
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

        await db.execute('''
          CREATE TABLE daily_forecasts (
            id INTEGER PRIMARY KEY,
            location_id INTEGER,
            date TEXT,
            date_epoch INTEGER,
            maxtemp_c REAL,
            maxtemp_f REAL,
            mintemp_c REAL,
            mintemp_f REAL,
            avgtemp_c REAL,
            avgtemp_f REAL,
            maxwind_mph REAL,
            maxwind_kph REAL,
            totalsnow_cm REAL,
            avghumidity REAL,
            daily_will_it_rain INTEGER,
            daily_chance_of_rain INTEGER,
            daily_will_it_snow INTEGER,
            daily_chance_of_snow INTEGER,
            condition_text TEXT,
            condition_icon TEXT,
            condition_code INTEGER,
            uv REAL,
            FOREIGN KEY (location_id) REFERENCES locations (id)
          )
        ''');

        await db.execute('''
          CREATE TABLE hourly_forecasts (
            id INTEGER PRIMARY KEY,
            daily_forecast_id INTEGER,
            time_epoch INTEGER,
            time TEXT,
            temp_c REAL,
            temp_f REAL,
            is_day INTEGER,
            condition_text TEXT,
            condition_icon TEXT,
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
            windchill_c REAL,
            windchill_f REAL,
            heatindex_c REAL,
            heatindex_f REAL,
            dewpoint_c REAL,
            dewpoint_f REAL,
            will_it_rain INTEGER,
            chance_of_rain INTEGER,
            will_it_snow INTEGER,
            chance_of_snow INTEGER,
            vis_km REAL,
            vis_miles REAL,
            FOREIGN KEY (daily_forecast_id) REFERENCES daily_forecasts (id)
          )
        ''');
      },
    );
  }
}
