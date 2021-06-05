import 'package:gym_tracker/src/data/model/BaseModel.dart';
import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';

class ExerciseModel implements BaseModel {
  int id;
  String name;
  MuscleGroupModel muscleGroup;

  ExerciseModel();
  ExerciseModel.name(this.name);
  ExerciseModel.allArgs(this.id, this.name, this.muscleGroup);

  @override
  fromMap(Map<String, dynamic> data) {
    MuscleGroupModel muscleGroupModel = MuscleGroupModel.allArgs(data['muscle_group_id'], data['muscle_group_name']);
    return ExerciseModel.allArgs(
        data['id'], data['name'], muscleGroupModel);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'muscle_group_id': muscleGroup.id};
  }

  @override
  String toString() {
    return "id = $id, name = $name, muscle_group_id = ${muscleGroup.id}";
  }
}
