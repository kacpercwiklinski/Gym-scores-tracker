import 'package:gym_tracker/src/data/model/BaseModel.dart';

class SetModel implements BaseModel {
  int id;
  int scoreId;
  num weight;
  int repeats;

  SetModel();
  SetModel.allArgs(this.id, this.scoreId, this.weight, this.repeats);

  @override
  fromMap(Map<String, dynamic> data) {
    return SetModel.allArgs(
        data['id'], data['score_id'], data['weight'], data['repeats']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'score_id': scoreId,
      'weight': weight,
      'repeats': repeats
    };
  }

  @override
  String toString() {
    return "id = $id, score_id = $scoreId, weight = $weight, repeats = $repeats";
  }
}
