//
//
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class StorageService {
//   static final StorageService instance = StorageService._init();
//
//   static Database? _database;
//
//   StorageService._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase('my_weathers.db');
//     return _database!;
//   }
//
//   Future<Database> _initDatabase(String path) async {
//     var databasePath = await getDatabasesPath();
//
//     String filePath = join(databasePath, path);
//     return await openDatabase(filePath, version: 1, onCreate: _onCreate);
//   }
//
//   Future _onCreate(Database db, int version) async {
//     const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
//     const textType = 'TEXT NOT NULL';
//
//     await db.execute('''
//     CREATE TABLE $tableNotes (
//       ${FieldsConst.id} $idType,
//       ${FieldsConst.title} $textType,
//       ${FieldsConst.description} $textType,
//       ${FieldsConst.time} $textType
//     )
//   ''');
//   }
//
//   Future<Note> createNote(Note note) async {
//     final db = await instance.database;
//     note.id = await db.insert(tableNotes, note.toJson());
//     return note;
//   }
//
//   Future<int> updateNote(Note note) async {
//     final db = await instance.database;
//     return await db.update(tableNotes, note.toJson(), whereArgs: [note.id], where: '${FieldsConst.id} = ?');
//   }
//
//   Future<Note> getNote(int id) async {
//     final db = await instance.database;
//     final maps = await db.query(tableNotes, columns: FieldsConst.colField, where: '${FieldsConst.id} = ?', whereArgs: [id]);
//     if (maps.isNotEmpty) {
//       return Note.fromJson(maps.first);
//     } else {
//       throw Exception('ID $id not found');
//     }
//   }
//
//   Future<List<Note>> getAllNotes() async {
//     final db = await instance.database;
//
//     final orderBy = '${FieldsConst.title} ASC';
//     final result = await db.query(tableNotes, orderBy: orderBy);
//
//     print('res-->' + result.toString());
//
//     return result.map((e) => Note.fromJson(e)).toList();
//   }
//
//   Future<int> delete(int id) async {
//     final db = await instance.database;
//     return await db.delete(tableNotes, where: '${FieldsConst.id} = ?', whereArgs: [id]);
//   }
//
//   Future close() async {
//     final db = await instance.database;
//
//     db.close();
//   }
// }

import 'package:sqflite/sqflite.dart';
import 'package:weather_show/src/model/forecast_weather_data_model.dart';

abstract class StorageService {

  Future<Database> initDataBase(String path);

  Future onCreate(Database db, int version);

  Future<ForecastWeather> addCityWeather(ForecastWeather city);

  Future<int> updateCityWeather(int id);

  Future<ForecastWeather> getCityWeather(int id);

  Future<List<Map<String,dynamic>>> getAllWeather();

  Future<int> deleteWeather(int id);

  Future<void> close();
}