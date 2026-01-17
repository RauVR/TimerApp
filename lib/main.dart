import 'package:flutter/material.dart';
import 'package:timerapp/screens/Clock.dart';
import 'package:timerapp/screens/timer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    WakelockPlus.enable();


    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      home: const Clock(),

    );
  }
}
