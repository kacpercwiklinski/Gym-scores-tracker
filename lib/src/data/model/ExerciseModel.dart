import 'package:gym_tracker/src/data/model/BaseModel.dart';

class ExerciseModel implements BaseModel {
  int id;
  String name;
  int muscleGroupId;
  String muscleGroupName;

  ExerciseModel();
  ExerciseModel.name(this.name);
  ExerciseModel.allArgs(this.id, this.name, this.muscleGroupId);
  ExerciseModel.joined(this.id, this.name, this.muscleGroupName);

  @override
  fromMap(Map<String, dynamic> data) {
    return ExerciseModel.allArgs(
        data['id'], data['name'], data['muscle_group_id']);
  }

  fromMapJoined(Map<String, dynamic> data) {
    return ExerciseModel.joined(
        data['id'], data['name'], data['muscle_group_name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'muscle_group_id': muscleGroupId};
  }
}
