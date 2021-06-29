import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/ScoreModel.dart';
import 'package:gym_tracker/src/data/model/SetModel.dart';
import 'package:gym_tracker/src/data/repository/SetRepository.dart';

class AddSetView extends StatefulWidget {
  final ScoreModel _scoreModel;

  const AddSetView(this._scoreModel, {Key key}) : super(key: key);

  @override
  _AddSetViewState createState() => _AddSetViewState(_scoreModel);
}

class _AddSetViewState extends State<AddSetView> {
  final _formKey = GlobalKey<FormState>();
  final ScoreModel _scoreModel;
  final SetRepository _setRepository = SetRepository();

  final _repeatsValueController = TextEditingController();
  final _weightValueController = TextEditingController();

  _AddSetViewState(this._scoreModel);

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
          title: Text("Nowa seria - ${_scoreModel.exercise.name}"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: TextFormField(
                  controller: _weightValueController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(), labelText: "Ciężar"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pole ciężaru nie może być puste";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
                child: TextFormField(
                  controller: _repeatsValueController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Ilość powtórzeń"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pole powtórzen nie może być puste";
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              SetModel _setToInsert = SetModel.allArgs(
                  0,
                  _scoreModel.id,
                  double.parse(_weightValueController.text),
                  int.parse(_repeatsValueController.text));
              try {
                await _setRepository.insert(_setToInsert);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Dodano nową serie!")));
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Błąd przy dodawaniu nowej serii!")));
              }
              Navigator.pop(context);
            }
          },
          label: Text("Zatwierdź"),
        ));
  }
}
