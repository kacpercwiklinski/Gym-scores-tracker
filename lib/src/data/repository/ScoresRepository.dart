import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/repository/BaseRepository.dart';

class ScoresRepository extends BaseRepository<ScoreModel>{
  ScoresRepository() : super(table: "scores", model: ScoreModel());


}