import 'package:flutter/material.dart';
import 'package:pflanzen_flutter/ui/mainScreen.dart';
import 'package:pflanzen_flutter/ui/plantFormScreen.dart';

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
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff41513f),
          onPrimary: Colors.white,
          secondary: Color(0xff5e7554),
          onSecondary: Colors.black,
          error: Color(0xfff44336),
          onError: Color(0xff2E3B4E),
          surface: Color(0xffDEDEDE),
          onSurface: Colors.black,
        ),
      ),
      home: const MainScreen(),
    );
  }
}
