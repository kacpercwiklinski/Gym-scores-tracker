import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';

class ScoreListTile extends StatefulWidget {
  final ScoreModel _scoreModel;

  const ScoreListTile(this._scoreModel, {Key key}) : super(key: key);

  @override
  _ScoreListTileState createState() => _ScoreListTileState(_scoreModel);
}

class _ScoreListTileState extends State<ScoreListTile> {
  final ScoreModel _scoreModel;

  _ScoreListTileState(this._scoreModel);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_scoreModel.exercise.name.toString()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: Use chip here?
          // Chip(
          //   label: Text("Biceps"),
          //   padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          //   backgroundColor: Colors.purple[100],
          // ),
          Text(_scoreModel.score.toString() + " kg"),
        ],
      ),
      subtitle: Text(_scoreModel.date.toString()),
    );
  }
}
