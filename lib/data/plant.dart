import 'dart:core';
import 'package:uuid/uuid.dart';

class Plant implements Comparable<Plant>{
  final String id;
  String name;
  String standort;
  int giessintervall;
  String zuletztGegossenDatum;
  String? imageUri;

  Plant(this.id, this.name, this.standort, this.giessintervall, this.zuletztGegossenDatum, [this.imageUri]);
  Plant.newId(this.name, this.standort, this.giessintervall, this.zuletztGegossenDatum, [this.imageUri]): id = Uuid().v1().toString();

  Map<String, Object?> toMap(){
    return {'id' : id, 'name' : name, 'standort' : standort, 'giessintervall' : giessintervall, 'zuletztGegossenDatum' : zuletztGegossenDatum, 'imageUri' : imageUri};
  }

  factory Plant.fromMap(Map<String, dynamic> map){
    return Plant(
        map['id'].toString(),
        map['name'].toString(),
        map['standort'].toString(),
        map['giessintervall'].toInt(),
        map['zuletztGegossenDatum'].toString(),
        map['imageUri']?.toString() ?? '');
  }

  @override
  int compareTo(Plant other) { // comparing which plant needs to be watered next
    return (calculateDaysUntilNextWatering((DateTime.parse(zuletztGegossenDatum)), DateTime.now(), giessintervall ))
        .compareTo
      (calculateDaysUntilNextWatering((DateTime.parse(other.zuletztGegossenDatum)), DateTime.now(), other.giessintervall ));
  }
  int calculateDaysUntilNextWatering(DateTime zuletztGegossenDatum, DateTime now, interval){
    final DateTime nextWateringDay = zuletztGegossenDatum.add(Duration(days: interval));
    return nextWateringDay.difference(now).inDays;
  }

  void watered(){
    zuletztGegossenDatum = DateTime.now().toString();
  }
}