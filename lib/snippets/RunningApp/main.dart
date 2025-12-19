import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/active_run_screen.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plan_detail_screen.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/plans_screen.dart';
import 'package:flutter_boilerplate/snippets/RunningApp/run_detail_screen.dart';
import 'dart:convert';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// void main() {
//   runApp(RunningApp());
// }

class RunningApp extends StatelessWidget {
  const RunningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Advanced Running Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blueAccent,
          ),
        ),
        // home: const HomeScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => PlansScreen(),
          '/plan_detail': (context) => PlanDetailScreen(),
          '/run_detail': (context) => RunDetailScreen(),
          // '/active_run': (context) => ActiveRunScreen(),
        });
  }
}
