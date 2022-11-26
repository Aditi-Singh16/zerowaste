import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static final DataBaseHelper instance = DataBaseHelper._init(); //making obj
  static Database? _database;

  DataBaseHelper._init();

  //returns our database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('zeroWaste.db');
    return _database!;
  }

  _initDB(String _dbName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: 1, onCreate: createTable);
  }

  Future createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
      uid VARCHAR(500) PRIMARY KEY,
      name TEXT NOT NULL,
      type VARCHAR(100) NOT NULL,
      phone VARCHAR(100) NOT NULL,
      addr VARCHAR(100) NOT NULL,
      email VARCHAR(100) NOT NULL
      )
      ''');
  }

  Future<int> insertUser(Map<String, dynamic> myuser) async {
    Database db = await instance.database;
    createTable(db, 1);
    return await db.insert(
      'users',
      myuser,
    );
  }

  Future<String> getUsersById(String id) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query('users',
        columns: ['uid', 'name', 'type', 'phone', 'email', 'addr'],
        where: 'uid = ?',
        whereArgs: [id]);
    return res[0]['type'];
  }

  Future<void> deleteUser(String id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'uid = ?',
      whereArgs: [id],
    );
  }
}
