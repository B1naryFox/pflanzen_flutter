import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/ui/viewModels/mainViewModel.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/ui/screens/plantFormScreen.dart';

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
    mainVM.fetchPlants();
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
      appBar: PlantAppBar(true,
      onSettingsReturned: (){
        _settingState();
      }),
      backgroundColor: Theme.of(context).colorScheme.surface,

// StreamBuilder baut die List-Ansicht, wenn die Pflanzen erhalten wurden

      body: 
      StreamBuilder<List<Plant>>(
          stream: mainVM.plantStream,
          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Text("Error: ${snapshot.error}", style: TextStyle(color: Colors.red));
            }else if (snapshot.hasData){
              plants = snapshot.data!;
              return _buildListView();
            }else{
              return Center(child: Text("Nutze den (+) Button um deine erste Pflanze anzulegen"));
            }


          }),

// AddButton: Weiterleitung zum Detail-/Form-Screen

      floatingActionButton: FloatingActionButton(
          onPressed: newPlant,
          child: Icon(Icons.add)),
    );
  }

// ListView: Liste der erstellten Pflanzen

  ListView _buildListView(){
    return ListView.builder(
      padding: EdgeInsets.all(10),
      scrollDirection: Axis.vertical,
      itemCount: plants.length,
      itemBuilder: (context, index) {
        var plant = plants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: Key(plant.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction){
              mainVM.deletePlant(plant);
              ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text('Pflanze gelöscht')));
            },
            background: Container(
              alignment: Alignment(0.9, 0.0),
                color: Theme.of(context).colorScheme.error,
                child: Icon(Icons.delete_forever, color: Theme.of(context).colorScheme.onPrimary,)),
            child: _buildPlantTile(plant)
          ),
        );
      },
    );
  }

// ListTile: Anzeige einer Pflanze mit Bild, Name, (Standort), nächstes Gießdatum und Gieß-Button

  ListTile _buildPlantTile(Plant plant){
    return ListTile(
      onTap: (){editPlant(plant);}, // Weiterleitung zum Detail-/Form-Screen mit zu editierender Pflanze
      leading: Padding(
        padding: const EdgeInsets.only(left: 9.0),
        child: SizedBox( // Bild der Pflanze
          width: 60,
          height: 60,
          child: Image(image: (plant.imageUri == null)
              ? AssetImage('assets/tuska_with_background.png')
              : FileImage(File(plant.imageUri!)) as ImageProvider,
          fit: BoxFit.fitWidth,),
        ),
      ),
      title: Text(plant.name, style: TextStyle(fontWeight: FontWeight.bold)),
      tileColor: Theme.of(context).colorScheme.onPrimary,
      subtitle: Text(mainVM.wateringMessage(plant)),
      trailing: IconButton( // Gieß-Button
          icon: Image.asset('assets/wateringCan.png'),
          iconSize: 100,
          onPressed: () {
            _showWateringAlert(plant);
          },

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
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PlantFormScreen())).then((value) {_settingState();});

    } else {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) => PlantFormScreen(plant: plant))).then((value) {_settingState();});

    }
  }

  void _settingState(){
    setState(() {
      mainVM.fetchPlants();
    });
  }

  void _showWateringAlert(Plant plant) {
    Widget cancelButton = TextButton(onPressed: (){
      Navigator.of(context, rootNavigator: true).pop();
    }, child: Text("Abbrechen"));

    Widget continueButton = TextButton(onPressed: (){
      mainVM.onPressWaterPlant(plant);
      Navigator.of(context, rootNavigator: true).pop();
    }, child: Text("OK"));

    AlertDialog alert = AlertDialog(
      title: Text("Gießen bestätigen"),
      content: Text("Bist du sicher, dass du ${plant.name} gegossen hast?"),
      actions: [continueButton, cancelButton],
    );

    showDialog(context: this.context, builder: (BuildContext context){
      return alert;
    });
  }

}


