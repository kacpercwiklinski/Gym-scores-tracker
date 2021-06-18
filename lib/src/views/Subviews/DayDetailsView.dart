import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/widget/DayExerciseCard.dart';
import 'package:intl/intl.dart';

class ScoreExpansionPanelItem {
  ScoreModel score;
  bool isExpanded = false;

  ScoreExpansionPanelItem(this.score);
}

class DayDetailsView extends StatefulWidget {
  final DateTime _day;
  final List<ScoreModel> _dayScores;

  DayDetailsView(this._day, this._dayScores, {Key key}) : super(key: key);

  @override
  _DayDetailsViewState createState() => _DayDetailsViewState(_day, _dayScores);
}

class _DayDetailsViewState extends State<DayDetailsView> {
  final DateTime _day;
  final List<ScoreModel> _dayScores;

  _DayDetailsViewState(this._day, this._dayScores);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('yMMMMd').format(_day)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: _dayScores
                .map((score) => DayExerciseCard(score, false))
                .toList(),
          ),
        ));
  }
}
