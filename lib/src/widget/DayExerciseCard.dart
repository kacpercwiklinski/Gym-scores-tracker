import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';

class DayExerciseCard extends StatefulWidget {
  final ScoreModel _scoreModel;
  final bool _isExpanded;

  const DayExerciseCard(this._scoreModel, this._isExpanded, {Key key})
      : super(key: key);

  @override
  _DayExerciseCardState createState() =>
      _DayExerciseCardState(_scoreModel, _isExpanded);
}

class _DayExerciseCardState extends State<DayExerciseCard> {
  ScoreModel _scoreModel;
  bool _isExpanded;

  _DayExerciseCardState(this._scoreModel, this._isExpanded);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      child: Card(
        elevation: 10,
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: (Text(
                _scoreModel.exercise.name,
              )),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_scoreModel.exercise.muscleGroup.name),
                  IconButton(
                      icon: _isExpanded
                          ? Icon(Icons.expand_less)
                          : Icon(Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      })
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 75),
              height: _isExpanded ? 32 : 0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("${_scoreModel.score} kg"),
                  Text("x ${_scoreModel.repeats}"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
