import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "CartDatabase.db";
  static const _databaseVersion = 1;

  static const tableCart = 'cart_table'; // テーブル名

  static const columnId = 'id';
  static const name = 'name';
  static const quantity = 'quantity';
  static const price = 'price';

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
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
          CREATE TABLE $tableCart (
            $columnId INTEGER PRIMARY KEY,
            $name TEXT NOT NULL,
            $quantity INTEGER NOT NULL,
            $price INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableCart, row);
  }

  Future<void> updateOrInsertProduct(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    final addName = row[DatabaseHelper.name];
    final addQuantity = row[DatabaseHelper.quantity];

    final existingProduct =
        await db!.query(tableCart, where: '$name = ?', whereArgs: [addName]);

    if (existingProduct.isNotEmpty) {
      final updatedCount = existingProduct.first[quantity] as int;
      final num = updatedCount + addQuantity;
      await db.update(
          tableCart,
          {
            DatabaseHelper.quantity: num,
          },
          where: '$name = ?',
          whereArgs: [addName]);
      if (kDebugMode) {
        print('追加登録: $addName , 追加数:$addQuantity, 合計数: $num');
      }
    } else {
      await db.insert(tableCart, row);
      if (kDebugMode) {
        print('新規登録: $addName , $addQuantity');
      }
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await instance.database;
    return await db!.query(tableCart);
  }

  Future<List<Item>> getAllAccount() async {
    Database? db = await instance.database;
    List<Map> results = await db!.query(tableCart);
    // map to account list
    return results.map((Map m) {
      int id = m["id"];
      String name = m["name"];
      int quantity = m["quantity"];
      int price = m["price"];
      return Item(id, name, quantity, price);
    }).toList();
  }

  Future<List<Item>> getMemos() async {
    final Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(tableCart);
    return List.generate(maps.length, (i) {
      print(maps[i]['id']);
      print(maps[i]['name']);
      print(maps[i]['quantity']);
      print(maps[i]['price']);
      return Item(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['price'],
      );
    });
  }

  Future<List<Item>> getCartItems() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> maps = await db!.query(tableCart);
    return List.generate(maps.length, (i) {
      return Item(
        maps[i][columnId],
        maps[i][name],
        maps[i][quantity],
        maps[i][price],
      );
    });
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    int id = row[columnId];
    return await db!
        .update(tableCart, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.database;
    return await db!.delete(tableCart, where: '$columnId = ?', whereArgs: [id]);
  }
}

class Item {
  final int id;
  final String name;
  final int quantity;
  final int price;

  Item(
    this.id,
    this.name,
    this.quantity,
    this.price,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }
}
