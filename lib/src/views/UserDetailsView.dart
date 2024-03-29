import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/ScoreRepository.dart';
import 'package:gym_tracker/src/views/Subviews/DayDetailsView.dart';
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

  DateTime startDate;
  DateTime endDate;

  _UserDetailsViewState(this._user) {
    // First day of current month minus 7 days
    startDate =
        DateTime.parse("${monday.year}-${DateFormat('MM').format(monday)}-01")
            .subtract(Duration(days: 7));
    // Last day of current month plus 7 days
    endDate = DateTime.parse(
            "${monday.year}-${DateFormat('MM').format(monday)}-${DateUtils.getDaysInMonth(monday.year, monday.month)}")
        .add(Duration(days: 7));
    _getScores();
  }

  _getScores() {
    _scoreRepository
        .getAllWhereUserAndDateBetween(
            user: _user, startDate: startDate, endDate: endDate)
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
      body: Container(
        child: Column(
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
              padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              itemCount: DateTime.daysPerWeek,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 48,
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
                                            BorderRadius.circular(16.0),
                                        side: BorderSide(
                                            color: monday
                                                    .add(Duration(days: index))
                                                    .isSameDate(DateTime.now())
                                                ? Colors.grey
                                                : Colors.white))),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.white),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.purple)),
                            onPressed: () {
                              DateTime day = monday.add(Duration(days: index));
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DayDetailsView(
                                              _user, day,
                                              dayScores: _monthScores
                                                  .where((score) => score.date
                                                      .isSameDate(day))
                                                  .toList())))
                                  .then((value) => _getScores());
                            },
                          ))),
                      Expanded(
                          flex: 5,
                          child: Row(
                            children: _monthScores
                                .where((element) => element.date.isSameDate(
                                    monday.add(Duration(days: index))))
                                .map((score) => score.exercise.muscleGroup.name)
                                .toSet() // Make elements unique
                                .map((muscleGroupName) => Text(muscleGroupName))
                                .toList(),
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ))
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 8, thickness: 0),
            )),
          ],
        ),
      ),
    );
  }
}
