import 'package:gym_tracker/src/data/model/BaseModel.dart';

class ExerciseModel implements BaseModel {
   int id;
   String name;
   int muscleGroupId;

   ExerciseModel();
   ExerciseModel.name(this.name);
   ExerciseModel.allArgs(this.id, this.name, this.muscleGroupId);

   @override
  fromMap(Map<String, dynamic> data) {
    return ExerciseModel.allArgs(data['id'], data['name'], data['muscle_group_id']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'muscle_group_id' : muscleGroupId};
  }
}