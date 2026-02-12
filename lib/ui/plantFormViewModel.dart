import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/data/plantRepository.dart';

class PlantFormViewModel {

  final PlantRepository _plantRepository = PlantRepository();


  void addPlant(Plant plant){
    _plantRepository.addPlant(plant);
  }

  void updatePlant(Plant plant){
    _plantRepository.updatePlant(plant);
  }

}