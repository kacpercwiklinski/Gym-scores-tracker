import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/ScoreRepository.dart';
import 'package:gym_tracker/src/widget/DayExerciseCard.dart';
import 'package:intl/intl.dart';
import 'AddScoreView.dart';

class ScoreExpansionPanelItem {
  ScoreModel score;
  bool isExpanded = false;

  ScoreExpansionPanelItem(this.score);
}

class DayDetailsView extends StatefulWidget {
  final UserModel _userModel;
  final DateTime _day;
  final List<ScoreModel> dayScores;

  DayDetailsView(this._userModel, this._day, {Key key, this.dayScores})
      : super(key: key);

  @override
  _DayDetailsViewState createState() =>
      _DayDetailsViewState(_userModel, _day, dayScores);
}

class _DayDetailsViewState extends State<DayDetailsView> {
  final UserModel _user;
  final DateTime _day;
  final ScoreRepository _scoreRepository = ScoreRepository();
  List<ScoreModel> dayScores;

  _DayDetailsViewState(this._user, this._day, this.dayScores) {
    if(dayScores.isEmpty){
      _getDayScores();
    }
  }


  _getDayScores() {
    // TODO: Find a way to expand only latest exercise
    _scoreRepository
        .getAllWhereUserAndDateBetween(user: _user, startDate: _day, endDate: _day)
        .then((value) => setState(() => {dayScores = value}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('yMMMMd').format(_day)),
          actions: [
            IconButton(
                icon: Icon(Icons.playlist_add_outlined),
                onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddScoreView(_user, _day)))
                    .then((value) => _getDayScores()))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: dayScores
                .asMap()
                .entries
                .map((score) => DayExerciseCard(
                    score.value,
                    score.key ==
                        dayScores.length - 1)) // Make last exercise expanded
                .toList(),
          ),
        ));
  }
}
