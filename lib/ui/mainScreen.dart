import 'package:flutter/material.dart';
import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'mainViewModel.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'plantFormScreen.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel mainVM = MainViewModel();
  List<Plant> plants = [];

  void _update(){
    setState(() {
      mainVM.fetchPlants();
      plants = mainVM.plants;
    });
  }

  @override
  void dispose(){
    mainVM.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context){
    _update();
    return Scaffold(
        appBar: PlantAppBar(),
        body: _buildListView(),
        floatingActionButton: FloatingActionButton(
            onPressed: onPressed,
            child: Icon(Icons.add)),
      );
  }

  ListView _buildListView(){
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: plants.length,
      itemBuilder: (context, index) {
        var plant = plants[index];
        return _buildPlantTile(plant);
      },
    ); // ListView
  }

  ListTile _buildPlantTile(Plant plant){
    return ListTile(
      leading: CircleAvatar(child: Text(plant.id.toString()),),
      title: Text(plant.name),
      subtitle: Text(mainVM.wateringMessage(plant)),
      trailing: IconButton(
          icon: Image.asset('assets/wateringCan.png'),
          iconSize: 50,
          onPressed: onPressed, // fun update WateredDate

      ),
    );
  }

  void onPressed() {
    _navigateToFormScreen(context, null);
    // _navigateToFormScreen(context, Plant(3, 'Test', 'standort', 3, DateTime.now().toString()));
    _update();
  }
  
  void _navigateToFormScreen(BuildContext context, Plant? plant){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlantFormScreen()));
  }
}
