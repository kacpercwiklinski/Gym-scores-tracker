import 'dart:async';
import 'package:gym_tracker/src/data/BaseModel.dart';
import 'package:gym_tracker/src/data/SQLiteDbProvider.dart';


abstract class BaseRepository<T extends BaseModel> {
  final String table;
  final T model;

  BaseRepository({this.table, this.model});

  Future<List<T>> getAll() async {
    var database = await SQLiteDbProvider.get.database;
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
    var database = await SQLiteDbProvider.get.database;
    final sqlQuery = "SELECT * FROM $table WHERE id = ?";
    final result = await database.rawQuery(sqlQuery, [id]);
    return model.fromMap(result.first);
  }


  void deleteById(int id) async {
    var database = await SQLiteDbProvider.get.database;
    final sqlQuery = "DELETE FROM $table WHERE id = ?";
    await database.rawQuery(sqlQuery, [id]);

    // TODO: Add error handling
  }

  insert(T item);

  update(T item);
}
