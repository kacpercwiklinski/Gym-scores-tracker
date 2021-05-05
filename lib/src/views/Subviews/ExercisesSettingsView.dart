import 'package:flutter/material.dart';

class ExercisesSettingsView extends StatefulWidget {
  @override
  _ExercisesSettingsViewState createState() => _ExercisesSettingsViewState();
}

class _ExercisesSettingsViewState extends State<ExercisesSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ustawienia ćwiczeń"),
      ),
      body: Container(
        child: Center(
          child: Text("ustawienia cwiczen body")
        ),
      ),
    );
  }
}
