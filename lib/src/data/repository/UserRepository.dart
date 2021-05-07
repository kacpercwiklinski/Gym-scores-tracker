import 'package:gym_tracker/src/data/repository/BaseRepository.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';

class UserRepository extends BaseRepository<UserModel> {
  UserRepository() : super(table: "users", model: UserModel());
}
