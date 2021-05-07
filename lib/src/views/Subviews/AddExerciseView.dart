import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ExerciseModel.dart';
import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';
import 'package:gym_tracker/src/data/repository/ExercisesRepository.dart';
import 'package:gym_tracker/src/data/repository/MuscleGroupRepository.dart';

class AddExerciseView extends StatefulWidget {
  @override
  _AddExerciseViewState createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends State<AddExerciseView> {
  final _formKey = GlobalKey<FormState>();
  final _exerciseRepository = ExercisesRepository();
  final _muscleGroupRepository = MuscleGroupRepository();

  final _nameController = TextEditingController();

  MuscleGroupModel _selectedMuscleGroup;

  List<MuscleGroupModel> _muscleGroups = [];

  _AddExerciseViewState() {
    _muscleGroupRepository
        .getAll()
        .then((value) => setState(() => _muscleGroups = value));
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dodaj nowe ćwiczenie"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Nazwa ćwiczenia"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nazwa ćwiczenia nie może być pusta.";
                    }
                    return null;
                  },
                ),
              ),
              FormField(
                builder: (FormFieldState<MuscleGroupModel> state) {
                  return Column(
                    children: [
                      Wrap(
                          children: _muscleGroups
                              .map((muscleGroup) => ChoiceChip(
                                    label: Text(muscleGroup.name),
                                    selected:
                                        _selectedMuscleGroup == muscleGroup,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _selectedMuscleGroup =
                                            selected ? muscleGroup : null;
                                      });
                                      state.didChange(muscleGroup);
                                    },
                                  ))
                              .toList()),
                      state.hasError
                          ? Text(state.errorText,
                              style: TextStyle(color: Colors.red))
                          : Text("")
                    ],
                  );
                },
                validator: (value) {
                  if (value == null) {
                    return "Wybierz kategorię ćwiczenia!";
                  }
                  return null;
                },
                //initialValue: null,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.purple[700],
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ExerciseModel _exerciseModelToInsert = ExerciseModel.toInsert(
                  _nameController.text, _selectedMuscleGroup.id);
              try {
                await _exerciseRepository.insert(_exerciseModelToInsert);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Dodano nowe ćwiczenie!")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Błąd przy dodawaniu nowego ćwiczenia!")));
              }
              Navigator.pop(context);
            }
          },
          //icon: Icon(Icons.save),
          label: Text("Zatwierdź"),
        ));
  }
}
