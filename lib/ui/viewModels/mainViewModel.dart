import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pflanzen_flutter/data/plantRepository.dart';
import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/data/SharedPrefService.dart';

class MainViewModel extends ChangeNotifier{
  final PlantRepository _plantRepository = PlantRepository();
  final streamController = StreamController<List<Plant>>();
  Stream<List<Plant>> get plantStream => streamController.stream;

  List<Plant> _plants = [];
  Sorting? _sortingBy;

  Future<void> fetchPlants() async {
    _plants = await _plantRepository.loadPlants();
    streamController.sink.add(sorted(sortingBy, _plants));
  }

  void onPressWaterPlant(Plant plant){
    plant.watered();
    _plantRepository.updatePlant(plant);
    fetchPlants();
  }

  void deletePlant(Plant plant){
    _plantRepository.deletePlant(plant.id);
    fetchPlants();
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

  Sorting get sortingBy{
    _sortingBy = Sorting.values[SharedPrefService.getSortIndex() ?? 0];
    return _sortingBy!;
  }

  List<Plant> sorted(Sorting by, List<Plant> plants){
    switch (by) {
      case Sorting.NAME:
        plants.sort((a, b) => a.name.compareTo(b.name));
      case Sorting.GIESSDATUM:
        plants.sort((a, b) => a.compareTo(b)); // implemented in plant.dart
      default:
        throw UnsupportedError('Implementation of more sorting options');
    }
    return plants;
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}


