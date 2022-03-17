import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entity/car.dart';

///sqfLite使用
class DatabaseHelper {
  static String carTableName = 'car'; //表名
  static final String _createCarSql =
      'CREATE TABLE $carTableName(id INTEGER PRIMARY KEY, brand TEXT, type TEXT, start INTEGER)'; //建表语句
  static final String _dropCarSql =
      'DROP TABLE IF EXISTS $carTableName'; //删除表语句

  DatabaseHelper get instance => _instance;

  ///单例
  DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static late final DatabaseHelper _instance = DatabaseHelper._internal();

  ///获取数据库路径
  Future<String> getDbPath() async {
    return join(await getDatabasesPath(), 'car.db');
  }

  ///创建数据库
  Future<Database> createDb() async {
    String path = await getDbPath();
    Database db = await openDatabase(
      path,
      version: 1,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    debugPrint('DatabaseHelper._onCreate newVersion $newVersion');
    Batch batch = db.batch();
    batch.execute(_dropCarSql);
    batch.execute(_createCarSql);
    await batch.commit();
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint(
        'DatabaseHelper._onUpgrade oldVersion $oldVersion, newVersion $newVersion');
    Batch batch = db.batch();
    await batch.commit();
  }

  ///插入数据
  Future<int> insertCar(Car car) async {
    Database db = await openDb();
    int result = await db.insert(
      carTableName,
      car.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.close();
    return result;
  }

  ///使用事务插入数据
  Future<List<Object?>> insertCarList(List<Car> carList) async {
    if (carList.isEmpty) return [];
    Database db = await openDb();
    Batch batch = db.batch();
    for (Car car in carList) {
      batch.insert(
        carTableName,
        car.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    List<Object?> result = await batch.commit();
    await db.close();
    return result;
  }

  ///删除数据
  Future<int> deleteCar(int id) async {
    Database db = await openDb();
    int result =
        await db.delete(carTableName, where: 'id = ?', whereArgs: [id]);
    await db.close();
    return result;
  }

  ///更新数据
  Future<int> updateCar(Car car) async {
    Database db = await openDb();
    int result = await db.update(carTableName, car.toJson(),
        where: 'id = ?', whereArgs: [car.id]);
    await db.close();
    return result;
  }

  ///查询数据
  Future<List<Car>> getCarList() async {
    Database db = await openDb();
    List<Map<String, dynamic>> result = await db.query(carTableName);
    await db.close();
    final carList =
        List.generate(result.length, (index) => Car.fromJson(result[index]));
    return carList;
  }

  ///获取表数据总数
  Future<int> getTableCount() async {
    Database db = await openDb();
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM $carTableName');
    await db.close();
    int? count = Sqflite.firstIntValue(result);
    return count ?? 0;
  }

  Future<Database> openDb() async {
    String path = await getDbPath();
    return openDatabase(path);
  }
}
