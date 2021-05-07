import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/model/BaseModel.dart';
import 'package:gym_tracker/src/data/repository/UserRepository.dart';

class UserModel implements BaseModel {
  int id;
  String name;

  UserModel();
  UserModel.name(this.name);
  UserModel.allArgs(this.id, this.name);

  fromMap(Map<String, dynamic> data) {
    return UserModel.allArgs(data['id'], data['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

class UserGridItem extends StatelessWidget {
  final UserModel user;
  final _userRepository = UserRepository();
  final Function() refreshUserListCallback;

  UserGridItem({Key key, this.user, this.refreshUserListCallback})
      : super(key: key);

  void showPersonsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text("${user.name}'s scores"),
                ),
                body: UserDetails(user: user))));
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
                    _userRepository.deleteById(user.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Usunięto strongmana!")));
                    refreshUserListCallback();
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
            Text(user.name),
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

class UserDetails extends StatefulWidget {
  final UserModel user;

  const UserDetails({Key key, this.user}) : super(key: key);

  @override
  _UserDetailsState createState() => _UserDetailsState(this.user);
}

class _UserDetailsState extends State<UserDetails> {
  UserModel _user;

  _UserDetailsState(this._user);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${_user.name} ma id = ${_user.id}"),
    );
  }
}
