import 'package:flutter/material.dart';

class ExercisesSettingsSubview extends StatefulWidget {
  @override
  _ExercisesSettingsSubviewState createState() => _ExercisesSettingsSubviewState();
}

class _ExercisesSettingsSubviewState extends State<ExercisesSettingsSubview> {
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
