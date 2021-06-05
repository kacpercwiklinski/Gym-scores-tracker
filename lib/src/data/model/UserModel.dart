import 'package:gym_tracker/src/data/model/BaseModel.dart';

class UserModel implements BaseModel {
  int id;
  String name;

  UserModel();
  UserModel.name(this.name);
  UserModel.allArgs(this.id, this.name);

  fromMap(Map<String, dynamic> data) {
    return UserModel.allArgs(data['id'], data['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
