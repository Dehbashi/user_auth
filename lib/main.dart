import 'package:flutter/material.dart';
import 'package:login_app3/screen/admin_page.dart';
import 'package:login_app3/screen/homescreen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:workmanager/workmanager.dart';

sendDate() {
  print('Hiiiiiiiiiii');
}

const task = 'firsttask';
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    switch (taskName) {
      case 'firsttask':
        sendDate();
        break;
      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
      ),
      home: HomeScreen(),
    );
  }
}
