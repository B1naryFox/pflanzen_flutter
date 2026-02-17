import 'package:flutter/material.dart';

import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'mainViewModel.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'plantFormScreen.dart';

// MainScreen/Homepage: Zeigt die Liste an gespeicherten Pflanzen an, einen SettingsMenu und einen AddButton
class MainScreen extends StatefulWidget{
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final MainViewModel mainVM = MainViewModel();
  late List<Plant> plants;

  
  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    mainVM.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: PlantAppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
// FutureBuilder baut die List-Ansicht, wenn die Pflanzen erhalten wurden
      body: FutureBuilder<List<Plant>>(
          future: mainVM.getPlants(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator(),);
              }
              plants = snapshot.data;
              return _buildListView();
      }),
// AddButton: Weiterleitung zum Detail-/Form-Screen
      floatingActionButton: FloatingActionButton(
          onPressed: newPlant,
          child: Icon(Icons.add)),
    );
  }

// ListView
  ListView _buildListView(){
    return ListView.builder(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: plants.length,
      itemBuilder: (context, index) {
        var plant = plants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _buildPlantTile(plant),
        );
      },
    );
  }
// ListTile
  ListTile _buildPlantTile(Plant plant){
    return ListTile(
      onTap: (){editPlant(plant);}, // Weiterleitung zum Detail-/Form-Screen mit zu editierender Pflanze
      leading: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: CircleAvatar(child: Text(plant.id.toString()),),
      ),
      title: Text(plant.name, style: TextStyle(fontWeight: FontWeight.bold)),
      tileColor: Theme.of(context).colorScheme.onPrimary,
      subtitle: Text(mainVM.wateringMessage(plant)),
      trailing: IconButton(
          icon: Image.asset('assets/wateringCan.png'),
          iconSize: 50,
          onPressed: () {}, // TODO AlertConfirmation -> Update des Letzten Giessdatums -> Update WateringMessage

      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      contentPadding: EdgeInsets.only(bottom: 2.0),
    );
  }

  void newPlant() async {
    _navigateToFormScreen(context, null);
  }

  void editPlant(Plant plant) async {
    _navigateToFormScreen(context, plant);
  }
  
  Future<void> _navigateToFormScreen(BuildContext context, Plant? plant) async {
    if (plant == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlantFormScreen())).then((value){
        setState(() {
          mainVM.fetchPlants();
          plants = mainVM.plants;
        });
      });

    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => PlantFormScreen(plant: plant))).then((value){
        setState(() {
          mainVM.fetchPlants();
          plants = mainVM.plants;
        });
      });
    }
  }
}


