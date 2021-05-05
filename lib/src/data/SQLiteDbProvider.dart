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

  Future<Database> get database async {
    if (!isInitialized) await _init();
    return _db;
  }

  _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "GymTrackerDB.db");
    _db = await openDatabase(path, version: 1,
        onOpen: (db) async {
//deleteDatabase(path);
        },
        onConfigure: (db) async {

        },
        onCreate: (Database db, int version) async {
      await db
          .execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)");
      await db.execute(
          "CREATE TABLE muscle_groups (id INTEGER PRIMARY KEY, name TEXT)");

      await db.execute(
          "CREATE TABLE exercises (id INTEGER PRIMARY KEY, name TEXT, muscle_group_id INTEGER, FOREIGN KEY(muscle_group_id) REFERENCES muscle_groups(id))"
      );
      // Insert default users
      await db.execute(
          "INSERT INTO users ('id', 'name') values (?,?)", [0, "Kacper"]);

      // Insert default muscle groups
      await db.execute(
          "INSERT INTO muscle_groups ('id', 'name') values (?,?)", [0, "Klatka"]);
      await db.execute(
          "INSERT INTO muscle_groups ('id', 'name') values (?,?)", [1, "Plecy"]);
      await db.execute(
          "INSERT INTO muscle_groups ('id', 'name') values (?,?)", [2, "Barki"]);

      // Insert default exercises
      // await db.execute("INSERT INTO exercises ('id', 'name') values (?,?)",
      //     [0, "Lawka płaska"]);
      // await db.execute("INSERT INTO exercises ('id', 'name') values (?,?)",
      //     [1, "Martwy ciąg"]);
      // await db.execute(
      //     "INSERT INTO exercises ('id', 'name') values (?,?)", [2, "Francuz"]);
      // await db.execute("INSERT INTO exercises ('id', 'name') values (?,?)",
      //     [3, "Bicepsy hantlem"]);
    });
  }

  // // User related queries
  // Future<List<User>> getAllUsers() async {
  //   final db = await database;
  //   List<Map> results =
  //       await db.query("users", columns: User.columns, orderBy: "id ASC");
  //   List<User> users = [];
  //
  //   results.forEach((result) {
  //     User user = User.fromMap(result);
  //     users.add(user);
  //   });
  //   return users;
  // }
  //
  // Future<User> getUserById(int id) async {
  //   final db = await database;
  //   var result = await db.query("users", where: "id = ", whereArgs: [id]);
  //   return result.isNotEmpty ? User.fromMap(result.first) : Null;
  // }
  //
  // insertUser(User user) async {
  //   final db = await database;
  //   var maxIdResult =
  //       await db.query("SELECT MAX(id)+1 as last_inserted_id FROM users");
  //   var id = maxIdResult.first["last_inserted_id"];
  //   var result = await db.rawInsert(
  //       "INSERT INTO users"
  //       "(id,name)"
  //       "VALUES (?,?)",
  //       [id, user.name]);
  //   return result;
  // }
  //
  // updateUser(User user) async {
  //   final db = await database;
  //   var result = await db
  //       .update("users", user.toMap(), where: "id = ?", whereArgs: [user.id]);
  //   return result;
  // }
  //
  // deleteUser(int id) async {
  //   final db = await database;
  //   db.delete("users", where: "id = ", whereArgs: [id]);
  // }
}
