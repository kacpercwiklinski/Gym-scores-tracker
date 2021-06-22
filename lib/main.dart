// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:gym_tracker/src/views/GymTrackerView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Gym Tracker',
      theme: ThemeData(
        primaryColorDark: Colors.purple[900],
        primaryColor: Colors.purple[800],
        primaryColorLight: Colors.purple[600],
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.purple[700]),
      ),
      home: GymTracker(),
    );
  }
}
