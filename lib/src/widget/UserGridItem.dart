import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/UserRepository.dart';
import 'package:gym_tracker/src/views/UserDetailsView.dart';

class UserGridItem extends StatelessWidget {
  final UserModel _user;
  final _userRepository = UserRepository();
  final Function() _refreshUserListCallback;

  UserGridItem(Key key, this._user, this._refreshUserListCallback)
      : super(key: key);

  void showPersonsPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => UserDetailsView(user: _user)));
  }

  Future<void> showDeletePersonDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Czy na pewno chcesz usunąć?"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                Text('Potwierdz usunięcie użytkownika.'),
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
                    _userRepository.deleteById(_user.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usunięto strongmana!")));
                    _refreshUserListCallback();
                    Navigator.of(context).pop();
                  },
                  child: Text("Usuń"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(_user.name),
            IconButton(
                onPressed: () async {
                  await showDeletePersonDialog(context);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
        Divider(),
        TextButton.icon(
            onPressed: () => showPersonsPage(context),
            icon: Icon(Icons.person),
            label: Text("Podgląd")),
      ],
    ));
  }
}
