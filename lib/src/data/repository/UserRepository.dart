import 'package:gym_tracker/src/data/repository/BaseRepository.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';


import '../SQLiteDbProvider.dart';

class UserRepository extends BaseRepository<UserModel>{
  UserRepository() : super(table: "users", model: UserModel());

  @override
  insert(UserModel item) async {
    var id = await getNextId();

    final sqlQuery = "INSERT INTO $table (id, name) VALUES (?, ?)";
    final result = await database.rawInsert(sqlQuery, [id, item.name]);
    return result;
  }
}