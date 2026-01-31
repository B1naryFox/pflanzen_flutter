import 'plant.dart';
import 'dart:convert';

class PlantService{

  static Map<String, Object?> plantToMap(Plant plant){
    return {'id' : plant.id, 'name' : plant.name, 'standort' : plant.standort, 'giessintervall' : plant.giessintervall, 'zuletztGegossenDatum' : plant.zuletztGegossenDatum, 'imageUri' : plant.imageUri};
  }

  static Plant mapToPlant(Map<String, dynamic> map){
    return Plant(
        map['id'].toInt(),
        map['name'].toString(),
        map['standort'].toString(),
        map['giessintervall'].toInt(),
        map['zuletztGegossenDatum'].toString(),
        map['imageUri']?.toString() ?? '');
  }

  static String getWateringText(int giessintervall, String zuletztGegossenDatum){
    calculateDaysUntilNextWatering(giessintervall, zuletztGegossenDatum);
    return '';
  }

  static int calculateDaysUntilNextWatering(int giessintervall, String zuletztGegossenDatum){
    return 0;
  }
}
