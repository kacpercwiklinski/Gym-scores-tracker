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
        title: Text("Dodaj nowego strongmana"),
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
                    border: UnderlineInputBorder(), labelText: "Imie gnoja"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Wprowadz imie nowego strongmana!";
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
                        UserModel user = UserModel.name(_formController.text);
                        print(user.name);
                        await userRepository.insert(user); // TODO: Add error handling
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Dodano nowego gnoja!")));
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
