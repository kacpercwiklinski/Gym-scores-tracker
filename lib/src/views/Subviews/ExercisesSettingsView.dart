import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ExerciseModel.dart';
import 'package:gym_tracker/src/data/repository/ExercisesRepository.dart';
import 'package:gym_tracker/src/views/Subviews/AddExerciseView.dart';

class ExercisesSettingsView extends StatefulWidget {
  @override
  _ExercisesSettingsViewState createState() => _ExercisesSettingsViewState();
}

class _ExercisesSettingsViewState extends State<ExercisesSettingsView> {
  final ExercisesRepository _exercisesRepository = ExercisesRepository();

  List<ExerciseModel> _exercises = [];

  _ExercisesSettingsViewState() {
    _refreshExercisesList();
  }

  void _refreshExercisesList() {
    _exercisesRepository.getAll().then((value) {
      setState(() => _exercises = value);
    });
  }

  Future<void> _showDeleteExerciseDialog(
      BuildContext context, int exerciseId) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Czy na pewno chcesz usunąć te ćwiczenie?"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Text('Potwierdź usunięcie.'),
              ],
            )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Anuluj")),
              TextButton(
                  onPressed: () {
                    _exercisesRepository.deleteById(exerciseId);
                    _refreshExercisesList();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usunięto ćwiczenie!")));
                    Navigator.of(context).pop();
                  },
                  child: Text("Usuń"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ustawienia ćwiczeń"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddExerciseView()))
                .then((value) => _refreshExercisesList()),
          )
        ],
      ),
      body: ListView(
        children: _exercises
            .map((exercise) => ListTile(
                  title: Text(exercise.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(exercise.muscleGroup.name),
                        backgroundColor: Colors.purple[100],
                      ),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () =>
                              _showDeleteExerciseDialog(context, exercise.id))
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
