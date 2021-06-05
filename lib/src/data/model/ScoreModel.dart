import 'package:gym_tracker/src/data/model/BaseModel.dart';
import 'package:gym_tracker/src/data/model/ExerciseModel.dart';
import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';

class ScoreModel implements BaseModel {
  @override
  int id;
  UserModel user;
  ExerciseModel exercise;
  num score;
  int repeats;
  DateTime date;

  ScoreModel();
  ScoreModel.allArgs(this.id, this.user, this.exercise, this.score,
      this.repeats, this.date);

  @override
  fromMap(Map<String, dynamic> data) {
    UserModel _userModel = UserModel.allArgs(data['user_id'], data['user_name']);
    MuscleGroupModel _muscleGroupModel = MuscleGroupModel.allArgs(data['muscle_group_id'], data['muscle_group_name']);
    ExerciseModel _exerciseModel = ExerciseModel.allArgs(data['exercise_id'], data['exercise_name'], _muscleGroupModel);


    return ScoreModel.allArgs(data['id'], _userModel, _exerciseModel,
        data['score'], data['repeats'], DateTime.parse(data['date']));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user.id,
      'exercise_id': exercise.id,
      'score': score,
      'repeats': repeats,
      'date': date.toIso8601String()
    };
  }

  @override
  String toString() {
    return "id = $id, userId = ${user.id}, userName = ${user.name}, exerciseId = ${exercise.id}, exerciseName = ${exercise.name}, score = $score, repeats = $repeats, date = $date";
  }
}
