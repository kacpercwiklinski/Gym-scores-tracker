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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Powrót",
                      style: TextStyle(fontSize: 16.0),
                    )),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        MuscleGroupModel muscleGroup =
                            MuscleGroupModel.name(_formController.text);
                        await _muscleGroupsRepository
                            .insert(muscleGroup); // TODO: Add error handling
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Dodano nową grupe mięśniową!")));
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Zatwierdź",
                      style: TextStyle(fontSize: 16.0),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
