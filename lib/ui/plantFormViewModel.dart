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

  String? validator(String? value, String label) {
    if (value == null || value.isEmpty) {
      return '$label ist erforderlich';
    }
    if (label == 'Gießintervall (in Tagen)' && int.parse(value.toString()) <= 0) {
      return 'Gießintervall muss größer als 0 sein';
    }
    return null;
  }

}