import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/ScoreRepository.dart';
import 'package:gym_tracker/src/views/Subviews/AddScoreView.dart';
import 'package:gym_tracker/src/views/Subviews/DayDetailsView.dart';
import 'package:gym_tracker/src/widget/ScoreListTile.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class UserDetailsView extends StatefulWidget {
  final UserModel user;

  const UserDetailsView({Key key, this.user}) : super(key: key);

  @override
  _UserDetailsViewState createState() => _UserDetailsViewState(this.user);
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

class _UserDetailsViewState extends State<UserDetailsView> {
  UserModel _user;
  ScoreRepository _scoreRepository = ScoreRepository();
  List<ScoreModel> _monthScores = [];
  DateTime monday =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));

  _UserDetailsViewState(this._user) {
    _getScores();
  }

  _getScores() {
    _scoreRepository
        .getAllWithUserAndExerciseForMonth(userId: _user.id, day: monday)
        .then((value) => setState(() => _monthScores = value));
  }

  _handleWeekChange(int value) {
    var oldValue = monday;

    setState(() {
      monday = monday.add(Duration(days: 7 * value));
    });

    if (oldValue.month != monday.month) {
      _getScores();
    }
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
                    onPressed: () => _handleWeekChange(-1)),
                Text(
                    "Tydzien ${monday.weekOfYear} - ${DateFormat('yMMMMd').format(monday)}"),
                IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () => _handleWeekChange(1)),
              ],
            ),
          ),
          Expanded(
              child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
            itemCount: DateTime.daysPerWeek,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 60,
                //color: Theme.of(context).selectedRowColor,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 2))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: TextButton(
                          child: Text(
                              '${DateFormat('E').format(monday.add(Duration(days: index)))}'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0))),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.purple)),
                          onPressed: () {
                            DateTime day = monday.add(Duration(days: index));
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DayDetailsView(
                                            day,
                                            _monthScores
                                                .where((score) =>
                                                    score.date.isSameDate(day))
                                                .toList())))
                                .then((value) => _getScores());
                          },
                        ))),
                    Expanded(
                        flex: 6,
                        child: Row(
                          children: _monthScores
                              .where((element) => element.date.isSameDate(
                                  monday.add(Duration(days: index))))
                              .map((score) => score.exercise.muscleGroup.name)
                              .toSet() // Make elements unique
                              .map((muscleGroupName) => Text(muscleGroupName))
                              .toList(),
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        )),
                    Expanded(
                        child: IconButton(
                            icon: Icon(
                              Icons.addchart_outlined,
                            ),
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddScoreView(
                                              _user,
                                              monday.add(Duration(
                                                  days: index))))).then(
                                      (value) => _getScores()),
                                }))
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 8, thickness: 0),
          )),
        ],
      ),
    );
  }
}
