import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/ScoreRepository.dart';
import 'package:gym_tracker/src/widget/ScoreListTile.dart';

class UserDetailsView extends StatefulWidget {
  final UserModel user;

  const UserDetailsView({Key key, this.user}) : super(key: key);

  @override
  _UserDetailsViewState createState() => _UserDetailsViewState(this.user);
}

enum WeekChange { INCREASE, DECREASE }

class _UserDetailsViewState extends State<UserDetailsView> {
  UserModel _user;
  ScoreRepository _scoreRepository = ScoreRepository();
  List<ScoreModel> _scores = [];
  List<ScoreModel> _currentWeekScores = [];
  var weekNumber = 1;

  _UserDetailsViewState(this._user) {
    _scoreRepository
        .getAllWithUserNameAndExerciseName(userId: _user.id)
        .then((value) => setState(() => _scores = value));
  }

  _handleWeekChange(WeekChange weekChange) {
    setState(() {
      if (weekChange == WeekChange.DECREASE && weekNumber > 1) {
        weekNumber--;
      } else if (weekChange == WeekChange.INCREASE && weekNumber < 52) {
        weekNumber++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_user.name}'s scores"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () => _handleWeekChange(WeekChange.DECREASE)),
                Text("Tydzien $weekNumber"),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _handleWeekChange(WeekChange.INCREASE)),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            children: _scores.map((score) => ScoreListTile(score)).toList(),
          )),
        ],
      ),
    );
  }
}
