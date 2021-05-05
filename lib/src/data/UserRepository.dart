import 'package:gym_tracker/src/data/BaseRepository.dart';
import 'package:gym_tracker/src/data/UserModel.dart';


import 'SQLiteDbProvider.dart';

class UserRepository extends BaseRepository<UserModel>{
  UserRepository() : super(table: "users", model: UserModel());

  @override
  insert(UserModel item) async {
    var database = await SQLiteDbProvider.get.database;

    var maxIdResult = await database
        .rawQuery("SELECT MAX(id)+1 as last_inserted_id FROM $table");
    var id = maxIdResult.first["last_inserted_id"];

    final sqlQuery = "INSERT INTO $table (id, name) VALUES (?, ?)";
    final result = await database.rawInsert(sqlQuery, [id, item.name]);
    return result;
  }

  @override
  update(UserModel user) async {
    var database = await SQLiteDbProvider.get.database;
      var result = await database
          .update("users", user.toMap(), where: "id = ?", whereArgs: [user.id]);
      return result;
  }



}