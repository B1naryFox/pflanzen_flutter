import 'package:flutter/cupertino.dart';
import 'package:pflanzen_flutter/data/plantRepository.dart';
import 'package:pflanzen_flutter/data/plant.dart';

class MainViewModel extends ChangeNotifier{
  final PlantRepository _plantRepository = PlantRepository();

  List<Plant> _plants = [];
  Sorting sortingBy = Sorting.name; // TODO get from Settings

  List<Plant> get plants => sorted(sortingBy, _plants);

  Future<void> fetchPlants() async {
    _plants = await _plantRepository.loadPlants();
  }

  String wateringMessage(Plant plant){
    DateTime wateringDate = DateTime.parse(plant.zuletztGegossenDatum);
    var now = DateTime.now();
    int i = plant.calculateDaysUntilNextWatering(wateringDate, now, plant.giessintervall);
    if (i < 0) i = 0;
    switch(i) {
      case 0:
        return 'Heute ist Gießtag\uD83D\uDCA7';
      case 1:
        return 'Morgen gießen';
      default:
        return 'In $i Tagen gießen';
    }
  }

  List<Plant> sorted(Sorting by, List<Plant> plants){
    switch (by) {
      case Sorting.name:
        plants.sort((a, b) => a.name.compareTo(b.name));
      case Sorting.giessdatum:
        plants.sort((a, b) => a.compareTo(b)); // implemented in plant.dart
      default:
        throw UnsupportedError('Implementation of more sorting options');
    }
    return plants;
  }

  void dispose() {}

}

enum Sorting {name, giessdatum} // print(Color.blue.name); // 'blue'