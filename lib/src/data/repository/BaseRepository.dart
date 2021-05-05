import 'dart:async';
import 'package:gym_tracker/src/data/model/BaseModel.dart';
import 'package:gym_tracker/src/data/SQLiteDbProvider.dart';
import 'package:sqflite/sqflite.dart';


abstract class BaseRepository<T extends BaseModel> {
  final String table;
  final T model;
  Database database;

  BaseRepository({this.table, this.model})  {
    SQLiteDbProvider.get.database.then((value) => database = value);
  }

  Future<int> getNextId() async {
    var maxIdResult = await database
        .rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM $table");
    var id = maxIdResult.first["last_inserted_id"];
    return id;
  }

  Future<List<T>> getAll() async {
    if(database == null) return [];
    final sqlQuery = "SELECT * FROM $table";
    final results = await database.rawQuery(sqlQuery);
    List<T> items = [];


    results.forEach((result) {
        T itemFromMap = model.fromMap(result);
        items.add(itemFromMap);
      });

    return items;
  }

  Future<T> getById(int id) async {
    final sqlQuery = "SELECT * FROM $table WHERE id = ?";
    final result = await database.rawQuery(sqlQuery, [id]);
    return model.fromMap(result.first);
  }


  void deleteById(int id) async {
    final sqlQuery = "DELETE FROM $table WHERE id = ?";
    await database.rawQuery(sqlQuery, [id]);

    // TODO: Add error handling
  }

  update(T item) async {
    var result = await database
        .update(table, item.toMap(), where: "id = ?", whereArgs: [item.id]);
    return result;
  }

  insert(T item);
}
