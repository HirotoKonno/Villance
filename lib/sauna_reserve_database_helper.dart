import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SaunaReserveDatabaseHelper {
  static const _databaseName = "SaunaReserveDatabase.db";
  static const _databaseVersion = 1;

  static const tableSauna = 'sauna_table'; // テーブル名

  static const columnId = 'id';
  static const isToday = 'today';
  static const hourMinutesString = 'time';

  SaunaReserveDatabaseHelper._privateConstructor();

  static final SaunaReserveDatabaseHelper instance =
      SaunaReserveDatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
        join(getDatabasesPath().toString(), _databaseName),
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableSauna (
            $columnId INTEGER PRIMARY KEY,
            $isToday INTEGER NOT NULL,
            $hourMinutesString INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableSauna, row);
  }

  Future<bool> checkExistedTime(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    final hourMinutes = row[SaunaReserveDatabaseHelper.hourMinutesString];
    final List<Map<String, dynamic>> maps = await db!.query(tableSauna);
    final data = List.generate(maps.length, (i) {
      return ReservedSauna(
          maps[i][SaunaReserveDatabaseHelper.columnId],
          maps[i][SaunaReserveDatabaseHelper.isToday],
          maps[i][SaunaReserveDatabaseHelper.hourMinutesString]);
    });
    for (var i = 0; i < data.length; i++){
      if (data[i].hourMinutes == hourMinutes){
        if (kDebugMode) {
          print("${data[i].hourMinutes}は既に存在する");
        }
        return true;
      }
    }
    return false;
  }


  Future<void> addReserveTime(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    final isToday = row[SaunaReserveDatabaseHelper.isToday];
    final hourMinutes = row[SaunaReserveDatabaseHelper.hourMinutesString];

    final List<Map<String, dynamic>> maps = await db!.query(tableSauna);
    final data = List.generate(maps.length, (i) {
      return ReservedSauna(
          maps[i][SaunaReserveDatabaseHelper.columnId],
          maps[i][SaunaReserveDatabaseHelper.isToday],
          maps[i][SaunaReserveDatabaseHelper.hourMinutesString]);
    });
    for (var i = 0; i < data.length; i++){
      if (data[i].hourMinutes == hourMinutes){
        if (kDebugMode) {
          print("${data[i].hourMinutes}は既に存在する");
        }
        return;
      }
    }
    await db!.insert(tableSauna, row);
    if (kDebugMode) {
      print('追加: $isToday , $hourMinutes');
    }
  }

  Future<List<ReservedSauna>> getReservedTimes() async {
    final Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(tableSauna);
    return List.generate(maps.length, (i) {
      if (kDebugMode) {
        print(maps[i][columnId]);
        print(maps[i][isToday]);
        print(maps[i][hourMinutesString]);
      }
      return ReservedSauna(
          maps[i][columnId], maps[i][isToday], maps[i][hourMinutesString]);
    });
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(tableSauna);
  }

  Future<int> deleteTime(String time) async {
    Database? db = await instance.database;
    return await db!.delete(tableSauna, where: '$hourMinutesString = ?', whereArgs: [time]);
  }

  Future delete() async {
    Database? db = await instance.database;
    return await db!.delete(tableSauna);
  }
}

class ReservedSauna {
  final int id;
  final int isToday;
  final String hourMinutes;

  ReservedSauna(
    this.id,
    this.isToday,
    this.hourMinutes,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': isToday,
      'quantity': hourMinutes,
    };
  }
}
