import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/repository/SetRepository.dart';
import 'package:gym_tracker/src/views/Subviews/AddSetView.dart';

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
  SetRepository _setRepository = SetRepository();
  ScoreModel _scoreModel;
  bool _isExpanded;

  _DayExerciseCardState(this._scoreModel, this._isExpanded) {
    _getSets();
  }

  _getSets() {
    _setRepository
        .getAllByScoreId(_scoreModel.id)
        .then((value) => setState(() => {_scoreModel.setSets(value)}));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: Icon(Icons.add),
                onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddSetView(_scoreModel)))
                    .then((value) => _getSets()),
              ),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _scoreModel.sets.map((set) {
                  return Text("${set.weight} x ${set.repeats}");
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
