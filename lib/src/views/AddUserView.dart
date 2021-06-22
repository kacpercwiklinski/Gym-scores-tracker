import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/UserRepository.dart';

class AddUserView extends StatefulWidget {
  @override
  _AddUserFormState createState() => _AddUserFormState();
}

class _AddUserFormState extends State<AddUserView> {
  final _formKey = GlobalKey<FormState>();
  final userRepository = UserRepository();

  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dodaj nowego strongmana"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 8.0),
          child: TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
                border: UnderlineInputBorder(), labelText: "Imie"),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Wprowadz imie nowego strongmana!";
              }
              return null;
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            try {
              UserModel user = UserModel.name(_nameController.text);
              await userRepository.insert(user); // TODO: Add error handling
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Dodano nowego strongmana!")));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Błąd przy dodawaniu nowego strongmana!")));
            }
            Navigator.pop(context);
          }
        },
        //icon: Icon(Icons.save),
        label: Text("Zatwierdź"),
      ),
    );
  }
}
