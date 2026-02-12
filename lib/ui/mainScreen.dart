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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _buildListView(),
        floatingActionButton: FloatingActionButton(
            onPressed: newPlant,
            child: Icon(Icons.add)),
      );
  }

  ListView _buildListView(){
    return ListView.builder(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: plants.length,
      itemBuilder: (context, index) {
        var plant = plants[index];
        return _buildPlantTile(plant);
      },
    );
  }

  ListTile _buildPlantTile(Plant plant){
    return ListTile(
      onTap: (){_navigateToFormScreen(context, plant);},
      leading: CircleAvatar(child: Text(plant.id.toString()),),
      title: Text(plant.name, style: TextStyle(fontWeight: FontWeight.bold)),
      tileColor: Theme.of(context).colorScheme.onPrimary,
      subtitle: Text(mainVM.wateringMessage(plant)),
      trailing: IconButton(
          icon: Image.asset('assets/wateringCan.png'),
          iconSize: 50,
          onPressed: () {}, // fun update WateredDate

      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.only(bottom: 2.0),
    );
  }

  void newPlant() async {
    _navigateToFormScreen(context, null);
    // _navigateToFormScreen(context, Plant(3, 'Test', 'standort', 3, DateTime.now().toString()));
    _update();
  }
  
  Future<void> _navigateToFormScreen(BuildContext context, Plant? plant) async {
    if (plant == null) {
      final reloadPage = await Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlantFormScreen()));
      if (reloadPage) {
        _update();
      }
    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => PlantFormScreen(plant: plant)));
    }
  }
}
