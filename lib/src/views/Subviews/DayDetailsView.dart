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
  final List<ScoreModel> _dayScores;

  DayDetailsView(this._userModel, this._day, this._dayScores, {Key key})
      : super(key: key);

  @override
  _DayDetailsViewState createState() =>
      _DayDetailsViewState(_userModel, _day, _dayScores);
}

class _DayDetailsViewState extends State<DayDetailsView> {
  final UserModel _user;
  final DateTime _day;
  final ScoreRepository _scoreRepository = ScoreRepository();
  List<ScoreModel> dayScores;

  _DayDetailsViewState(this._user, this._day, this.dayScores);

  _getDayScores() {
    setState(() => dayScores
        .clear()); // TODO: Find a better way to expand only latest exercise
    _scoreRepository
        .getAllWithUserAndExerciseForDay(user: _user, day: _day)
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
