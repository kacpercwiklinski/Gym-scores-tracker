import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';
import 'package:gym_tracker/src/data/repository/MuscleGroupRepository.dart';

class AddMuscleGroupView extends StatefulWidget {
  @override
  _AddMuscleGroupViewState createState() => _AddMuscleGroupViewState();
}

class _AddMuscleGroupViewState extends State<AddMuscleGroupView> {
  final _formKey = GlobalKey<FormState>();
  final _muscleGroupsRepository = MuscleGroupRepository();

  final _formController = TextEditingController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dodaj nową grupę mięśniową"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 8.0),
            child: TextFormField(
              controller: _formController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(), labelText: "Nazwa grupy"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Nazwa grupy nie może być pusta.";
                }
                return null;
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.purple[700],
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              MuscleGroupModel muscleGroup =
                  MuscleGroupModel.name(_formController.text);

              try {
                await _muscleGroupsRepository.insert(muscleGroup);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Dodano nową grupe mięśniową!")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Błąd przy dodawaniu nowej grupy mięśniowej!")));
              }

              Navigator.pop(context);
            }
          },
          //icon: Icon(Icons.save),
          label: Text("Zatwierdź"),
        ));
  }
}
