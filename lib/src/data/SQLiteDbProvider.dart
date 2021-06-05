import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class SQLiteDbProvider {
  SQLiteDbProvider._();
  static final _instance = SQLiteDbProvider._();
  static SQLiteDbProvider get = _instance;
  bool isInitialized = false;
  Database _db;

  static const DEBUG_MODE = false;

  Future<Database> get database async {
    if (!isInitialized) await _init();
    return _db;
  }

  _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GymTrackerDB.db");

    if (DEBUG_MODE) await deleteDatabase(path);

    _db = await openDatabase(path,
        version: 1,
        onOpen: (db) async {},
        onConfigure: (db) async {}, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT , name TEXT)");
      await db.execute(
          "CREATE TABLE muscle_groups (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)");
      await db.execute(
          "CREATE TABLE exercises (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, muscle_group_id INTEGER, FOREIGN KEY(muscle_group_id) REFERENCES muscle_groups(id))");
      await db.execute(
          "CREATE TABLE scores (id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, exercise_id INTEGER, score REAL, repeats INTEGER, date TEXT, FOREIGN KEY(user_id) REFERENCES users(id), FOREIGN KEY(exercise_id) REFERENCES exercises(id))");

      // Insert default users
      await db.execute(
          "INSERT INTO users ('id', 'name') values (?,?)", [0, "Kacper"]);

      await db.execute(
          "INSERT INTO users ('id', 'name') values (?,?)", [1, "Kacper2"]);

      // Insert default muscle groups
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [0, "Klatka"]);
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [1, "Plecy"]);
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [2, "Barki"]);
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [3, "Biceps"]);
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [4, "Triceps"]);
      await db.execute(
          "INSERT INTO muscle_groups ('id', 'name') values (?,?)", [5, "Nogi"]);
      await db.execute("INSERT INTO muscle_groups ('id', 'name') values (?,?)",
          [6, "Brzuch"]);

      // Insert default exercises
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [0, "Lawka płaska", 0]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [1, "Martwy ciąg", 1]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [2, "OHP", 2]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [3, "Biceps hantlami", 3]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [4, "Francuz", 4]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [5, "Przysiad", 5]);
      await db.execute(
          "INSERT INTO exercises ('id', 'name', 'muscle_group_id') values (?,?,?)",
          [6, "Brzuszki", 6]);

      // Insert default scores
      await db.execute(
          "INSERT INTO scores ('id', 'user_id', 'exercise_id' , 'score', 'repeats', 'date') values (?,?,?,?,?,?)",
          [0, 0, 0, 92.5, 3, "2021-05-09 00:00:00.000"]);
      await db.execute(
          "INSERT INTO scores ('id', 'user_id', 'exercise_id' , 'score', 'repeats', 'date') values (?,?,?,?,?,?)",
          [1, 0, 2, 62.5, 5, "2021-05-09 00:00:00.000"]);
      await db.execute(
          "INSERT INTO scores ('id', 'user_id', 'exercise_id' , 'score', 'repeats', 'date') values (?,?,?,?,?,?)",
          [2, 0, 3, 17.5, 8, "2021-05-09 00:00:00.000"]);
      await db.execute(
          "INSERT INTO scores ('id', 'user_id', 'exercise_id' , 'score', 'repeats', 'date') values (?,?,?,?,?,?)",
          [3, 0, 1, 110, 8, "2021-05-09 00:00:00.000"]);
      await db.execute(
          "INSERT INTO scores ('id', 'user_id', 'exercise_id' , 'score', 'repeats', 'date') values (?,?,?,?,?,?)",
          [4, 1, 0, 15.5, 2, "2021-05-09 00:00:00.000"]);
    });
  }
}
