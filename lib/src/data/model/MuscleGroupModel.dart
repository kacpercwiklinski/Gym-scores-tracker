import 'package:gym_tracker/src/data/model/BaseModel.dart';

class MuscleGroupModel implements BaseModel {
  @override
  int id;
  String name;

  MuscleGroupModel();
  MuscleGroupModel.name(this.name);
  MuscleGroupModel.allArgs(this.id, this.name);

  @override
  BaseModel fromMap(Map<String, dynamic> data) {
    return MuscleGroupModel.allArgs(data['id'], data['name']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
