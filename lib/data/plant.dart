class Plant {
  final int id;
  String name;
  String standort;
  int giessintervall;
  String zuletztGegossenDatum;
  String? imageUri;

  Plant(this.id, this.name, this.standort, this.giessintervall, this.zuletztGegossenDatum, [this.imageUri = null]);

}