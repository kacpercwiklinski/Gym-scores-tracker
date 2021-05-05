import 'package:flutter/material.dart';
import 'package:gym_tracker/src/views/Subviews/ExercisesSettingsView.dart';
import 'package:gym_tracker/src/views/Subviews/MuscleGroupsSettingsView.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  List<SettingsElement> _settingsElements = <SettingsElement>[];

  _SettingsViewState() {
      _settingsElements = List.from([
        SettingsElement("Cwiczenia", null,
            () => openView(ExercisesSettingsView(), null)),
        SettingsElement("Grupy mięsniowe", null,
            () => openView(MuscleGroupSettingsView(), null)),
      ]);
  }

  void openView(Widget view, Function returnCallback) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => view))
        .then((value) => {
              if (returnCallback != null) {returnCallback()}
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ustawienia"),
      ),
      body: ListView.separated(
        itemCount: _settingsElements.length,
        itemBuilder: (BuildContext context, int index) {
          return _settingsElements[index];
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
    );
  }
}

class SettingsElement extends StatelessWidget {
  final String _buttonText;
  final IconData _icon;
  final Function() _callback;

  const SettingsElement(this._buttonText, this._icon, this._callback);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_buttonText),
      trailing: _icon != null ? Icon(_icon, color: Colors.black26) : null,
      onTap: _callback,
    );
  }
}
