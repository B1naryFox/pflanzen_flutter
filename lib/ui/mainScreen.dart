import 'dart:developer';

import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Text('Pflanzen')
        ),
        body: Column(),
        floatingActionButton: FloatingActionButton(onPressed: onPressed),
      );
  }

 void onPressed() => log('pressed1');
}
