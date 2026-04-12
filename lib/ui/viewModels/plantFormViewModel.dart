import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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

  void deletePlant(Plant plant){
    _plantRepository.deletePlant(plant.id);
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

  Future<String?> saveImageToPath(File? image) async {
    if (image == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    String imagePath = '${appDir.path}/$fileName';
    final File savedImage = await image.copy(imagePath);
    return savedImage.path;
  }
}