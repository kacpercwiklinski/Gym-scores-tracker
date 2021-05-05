import 'package:flutter/material.dart';

class MuscleGroupSettingsView extends StatefulWidget {
  @override
  _MuscleGroupSettingsViewState createState() => _MuscleGroupSettingsViewState();
}

class _MuscleGroupSettingsViewState extends State<MuscleGroupSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ustawienia grup mięsniowych"),
      ),
      body: Container(
        child: Center(
            child: Text("ustawienia grup mięsniowych body")
        ),
      ),
    );
  }
}
