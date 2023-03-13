import 'package:flutter/material.dart';
import 'package:flutter_factory_calendar_scheduler/database/drift_database.dart';
import 'package:flutter_factory_calendar_scheduler/screens/home_screen.dart';
import 'package:get_it/get_it.dart';
// import 'package:intl/date_symbol_data_file.dart';

void main() {
  final database = LocalDatabase();
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
