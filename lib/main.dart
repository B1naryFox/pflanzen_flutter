import 'package:flutter/material.dart';
import 'package:pflanzen_flutter/ui/mainScreen.dart';

void main() {
  runApp(const PflanzenFlutterApp());
}

class PflanzenFlutterApp extends StatelessWidget {
  const PflanzenFlutterApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pflanzen Dev',
      //debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const MainScreen(),
    );
  }
}

