import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
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
  List<ScoreExpansionPanelItem> scoreItems;

  _DayDetailsViewState(this._day, this._dayScores) {
    scoreItems =
        _dayScores.map((score) => ScoreExpansionPanelItem(score)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DateFormat('yMMMMd').format(_day)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  scoreItems[index].isExpanded = !scoreItems[index].isExpanded;
                });
              },
              children: scoreItems
                  .map<ExpansionPanel>((ScoreExpansionPanelItem item) {
                return ExpansionPanel( // TODO: Find a way to make ExpansionPanel rounded with padding
                  headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                      title: Text(item.score.exercise.name),
                      trailing: Text(item.score.exercise.muscleGroup.name),
                    );
                  },
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${item.score.score} kg"),
                        Text("x ${item.score.repeats}"),
                      ],
                    ),
                  ),
                  isExpanded: item.isExpanded,
                );
              }).toList(),
            ),
          ),
        ));
  }
}
