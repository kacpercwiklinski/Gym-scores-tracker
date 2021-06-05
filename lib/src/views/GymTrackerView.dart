import 'package:flutter/material.dart';
import 'package:gym_tracker/src/data/SQLiteDbProvider.dart';
import 'package:gym_tracker/src/data/model/UserModel.dart';
import 'package:gym_tracker/src/data/repository/UserRepository.dart';
import 'package:gym_tracker/src/views/AddUserView.dart';
import 'package:gym_tracker/src/views/SettingsView.dart';
import 'package:gym_tracker/src/widget/UserGridItem.dart';

class GymTracker extends StatefulWidget {
  @override
  _GymTrackerState createState() => _GymTrackerState();
}

class _GymTrackerState extends State<GymTracker> {
  List<UserModel> _users;
  DateTime currentDate = DateTime.now();
  UserRepository _userRepository = UserRepository();

  _GymTrackerState() {
    SQLiteDbProvider.get.database.then((value) => null);
    _refreshUserList();
  }

  void _refreshUserList() {
    _userRepository.getAll().then((users) => setState(() => {_users = users}));
  }

  Widget _buildGrid() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${currentDate.day > 9 ? currentDate.day : '0${currentDate.day}'}-${currentDate.month > 9 ? currentDate.month : '0${currentDate.month}'}-${currentDate.year}",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          TextButton.icon(
              onPressed: () {
                setState(() async {
                  final DateTime selectedDate = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025));
                  if (selectedDate != null && selectedDate != currentDate) {
                    setState(() {
                      currentDate = selectedDate;
                    });
                  }
                });
              },
              icon: Icon(Icons.date_range),
              label: Text("Wybierz dzień tygodnia")),
          Expanded(
              child: SafeArea(
                  top: false,
                  bottom: false,
                  child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      padding: const EdgeInsets.all(2.0),
                      childAspectRatio: 1.0,
                      children: _users != null
                          ? _users.map((user) {
                              return UserGridItem(
                                  GlobalKey(), user, _refreshUserList);
                            }).toList()
                          : [Text("Brak użytkowników!")])))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gym tracker"),
        actions: [
          IconButton(
              icon: Icon(
                Icons.person_add_alt_1,
              ),
              onPressed: () => {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddUserView()))
                        .then((value) => _refreshUserList()),
                  }),
          IconButton(
              icon: Icon(
                Icons.settings,
              ),
              onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingsView()))
                  }),
        ],
      ),
      body: Container(child: _buildGrid()),
    );
  }
}
