import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';

import 'BaseRepository.dart';

class MuscleGroupRepository extends BaseRepository<MuscleGroupModel> {
  MuscleGroupRepository()
      : super(table: "muscle_groups", model: MuscleGroupModel());
}
