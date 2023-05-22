

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:weather_show/src/service/storage/dao/weather_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/location_entity.dart';
part 'fav_city_db.g.dart';

@Database(version: 1, entities: [Location])
abstract class FavouriteCityDB extends FloorDatabase{
  LocationDao get locationDao;

  // static Future<Database> createDatabase() async {
  //   return await $FavouriteCityDB.
  // }
 }