import 'dart:ffi';

import 'package:gym_tracker/src/data/model/BaseModel.dart';

class ScoreModel implements BaseModel {
  @override
  int id;
  int userId;
  int exerciseId;
  Float score;
  DateTime date;

  ScoreModel();
  ScoreModel.allArgs(
      this.id, this.userId, this.exerciseId, this.score, this.date);

  @override
  fromMap(Map<String, dynamic> data) {
    return ScoreModel.allArgs(data['id'], data['user_id'], data['exercise_id'],
        data['score'], data['date']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exercise_id': exerciseId,
      'score': score,
      'date': date
    };
  }
}
