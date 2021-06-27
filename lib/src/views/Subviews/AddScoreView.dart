import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ExerciseModel.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/SetModel.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/ExercisesRepository.dart';
import 'package:gym_tracker/src/data/repository/ScoreRepository.dart';
import 'package:gym_tracker/src/data/repository/SetRepository.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AddScoreView extends StatefulWidget {
  final _user;
  final DateTime _day;

  const AddScoreView(this._user, this._day, {Key key}) : super(key: key);

  @override
  _AddScoreViewState createState() => _AddScoreViewState(this._user, this._day);
}

class _AddScoreViewState extends State<AddScoreView> {
  final _formKey = GlobalKey<FormState>();
  final UserModel _user;
  final DateTime _day;
  final ScoreRepository _scoreRepository = ScoreRepository();
  final ExercisesRepository _exercisesRepository = ExercisesRepository();
  final SetRepository _setRepository = SetRepository();

  List<ExerciseModel> _exercises = [];
  ExerciseModel _selectedExercise;

  final _repeatsValueController = TextEditingController();
  final _weightValueController = TextEditingController();

  _getExercises() {
    _exercisesRepository.getAll().then((value) => {
          setState(() => {_exercises = value})
        });
  }

  _AddScoreViewState(this._user, this._day) {
    _getExercises();
  }

  @override
  void dispose() {
    _repeatsValueController.dispose();
    _weightValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Add score - ${DateFormat('yMMMd').format(_day)} - ${DateFormat('E').format(_day)}")),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormField(builder: (FormFieldState<ExerciseModel> state) {
                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 8.0),
                        child: DropdownButton(
                          isExpanded: true,
                          hint: Text('Wybierz ćwiczenie'),
                          value: _selectedExercise,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedExercise = newValue;
                            });
                          },
                          items: _exercises.map((exercise) {
                            return DropdownMenuItem(
                              child: new Text(exercise.name),
                              value: exercise,
                            );
                          }).toList(),
                        )),
                    state.hasError
                        ? Text(state.errorText,
                            style: TextStyle(color: Colors.red))
                        : Text("")
                  ],
                );
              }, validator: (value) {
                if (_selectedExercise == null) {
                  return "Wybierz ćwiczenie!";
                }
                return null;
              }),
              Text(
                "Pierwsza seria",
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: TextFormField(
                  controller: _repeatsValueController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Ilość powtórzeń"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pole powtórzen nie może być puste";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: TextFormField(
                  controller: _weightValueController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Ciężar"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pole ciężaru nie może być puste";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ScoreModel score =
                  ScoreModel.allArgs(0, _user, _selectedExercise, _day);

              try {
                var scoreId = await _scoreRepository.insert(score);

                if (scoreId != null) {
                  SetModel firstSet = SetModel.allArgs(
                      0,
                      scoreId,
                      double.parse(_weightValueController.text),
                      int.parse(_repeatsValueController.text));
                  await _setRepository.insert(firstSet);
                } else {
                  throw Exception("Error when inserting new score!");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Dodano nowy wynik!")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Błąd przy dodawaniu nowego wyniku!")));
              }
              Navigator.pop(context);
            }
          },
          //icon: Icon(Icons.save),
          label: Text("Zatwierdź"),
        ));
  }
}
