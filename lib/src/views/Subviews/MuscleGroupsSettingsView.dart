import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/MuscleGroupModel.dart';
import 'package:gym_tracker/src/data/repository/MuscleGroupRepository.dart';
import 'package:gym_tracker/src/views/Subviews/AddMuscleGroupView.dart';

class MuscleGroupSettingsView extends StatefulWidget {
  @override
  _MuscleGroupSettingsViewState createState() =>
      _MuscleGroupSettingsViewState();
}

class _MuscleGroupSettingsViewState extends State<MuscleGroupSettingsView> {
  final MuscleGroupRepository _muscleGroupRepository = MuscleGroupRepository();
  List<MuscleGroupModel> _muscleGroups = [];

  _MuscleGroupSettingsViewState() {
    _refreshMuscleGroupList();
  }

  void _refreshMuscleGroupList() {
    _muscleGroupRepository.getAll().then((value) {
      setState(() => _muscleGroups = value);
    });
  }

  Future<void> showDeleteMuscleGroupDialog(
      BuildContext context, int muscleGroupId) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Czy na pewno chcesz usunąć tę grupę mięsniową?"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Text('Zostaną usunięte wszystke ćwiczenia z tej kategorii.'),
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
                    _muscleGroupRepository.deleteById(muscleGroupId);
                    _refreshMuscleGroupList();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usunięto grupe mięśniową!")));
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
        title: Text("Ustawienia grup mięsniowych"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMuscleGroupView()))
                .then((value) => _refreshMuscleGroupList()),
          )
        ],
      ),
      body: ListView(
        children: _muscleGroups
            .map((muscleGroup) => ListTile(
                  title: Text(muscleGroup.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDeleteMuscleGroupDialog(context, muscleGroup.id);
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}
