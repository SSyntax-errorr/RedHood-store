import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:store/Model/itemModel.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'itemsdb.db');
    return openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE items(
            itemID INTEGER PRIMARY KEY,
            itemName TEXT,
            itemPrice REAL,
            category TEXT,
            date TEXT,
            isCommon int DEFAULT 0
          );
        ''');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 3) {
        await db.execute('ALTER TABLE items ADD COLUMN isCommon INTEGER');
        await db.execute('UPDATE items SET isCommon = 0');
      }
    });
  }

  static Future<void> insertItem(DataModel item) async {
    final Database db = await database;
    await db.insert('items', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<DataModel>> retrieveItems() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (index) {
      return DataModel.fromJson(maps[index]);
    });
  }

  static Future<void> updateItem(DataModel item) async {
    final Database db = await database;
    await db.update(
      'items',
      item.toJson(),
      where: 'itemID = ?',
      whereArgs: [item.itemID],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> makeItemCommon(int itemId, int isCommon) async {
    final Database db = await database;
    await db.update(
      'items',
      {'isCommon': isCommon == 1 ? 0 : 1}, // Update only the 'isCommon' column
      where: 'itemID = ?',
      whereArgs: [itemId],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteItem(int id) async {
    final Database db = await database;
    await db.delete(
      'items',
      where: 'itemID = ?',
      whereArgs: [id],
    );
  }

  static Future<List<DataModel>?> getAllItems() async {
    final db = await initDatabase();

    final List<Map<String, dynamic>> maps = await db.query('DataModel');

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => DataModel.fromJson(maps[index]));
  }
}
