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
  UserRepository _userRepository = UserRepository();

  _GymTrackerState() {
    _refreshUserList();
  }

  void _refreshUserList() {
    _userRepository.getAll().then((users) => setState(() => {_users = users}));
  }

  Widget _buildGrid() => Container(
        child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            padding: const EdgeInsets.all(2.0),
            childAspectRatio: 1.5,
            children: _users.map((user) {
              return UserGridItem(user, _refreshUserList);
            }).toList()),
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
      body: _users != null
          ? _buildGrid()
          : Center(child: CircularProgressIndicator()),
    );
  }
}
