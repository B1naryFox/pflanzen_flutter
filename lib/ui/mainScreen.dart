import 'dart:developer';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pflanzen')
        ),
        body: _buildListView(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: onPressed),
      );
  }

  ListView _buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {

      },
    );
  }

  void onPressed() => log('pressed1');
}
