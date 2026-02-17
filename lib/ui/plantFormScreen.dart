import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/ui/plantFormViewModel.dart';

// Form zur Erstellung neuer Pflanzen oder zur Bearbeitung dieser
class PlantFormScreen extends StatefulWidget {
  final Plant? plant;

  const PlantFormScreen({super.key, this.plant});

  @override
  State<PlantFormScreen> createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantFormScreen> {
  // Controller zum Erreichen der Text Felder
  late final TextEditingController nameController = TextEditingController(text: widget.plant?.name);
  late final TextEditingController standortController = TextEditingController(text: widget.plant?.standort);
  late final TextEditingController intervallController = TextEditingController(text: widget.plant?.giessintervall.toString());
  late final TextEditingController dateController = TextEditingController(text: widget.plant?.zuletztGegossenDatum);
  final ImagePicker _imagePicker = ImagePicker();
  File? selectedImage; // TODO getFileFromURI

  final GlobalKey<FormState> _formKey = GlobalKey();
  final PlantFormViewModel formVM = PlantFormViewModel();

// Speicherung/Update einer Pflanze
  Future<void> onSave() async {
    final bool isValid = _formKey.currentState?.validate() ?? false; // Validierung der Text Felder
    if (!isValid) return;
    Plant plant;
    if (widget.plant == null) {
      plant = Plant.newId(nameController.text, standortController.text,
          int.parse(intervallController.text), dateController.text,); // TODO PathToImage
      formVM.addPlant(plant);
    }else{
        plant = Plant(widget.plant!.id, nameController.text, standortController.text, int.parse(intervallController.text), dateController.text);
        formVM.updatePlant(plant);
    }
// Return to Main/Homescreen
    Navigator.pop(
        context as BuildContext
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Navigationsbar
        appBar: PlantAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
// Form
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
// Text Felder
                children: [
                  _buildTextField(0, 'Name', TextInputType.name, false, nameController),
                  _buildTextField(1, 'Standort', TextInputType.name, false, standortController),
                  _buildTextField(2, 'Gießintervall (in Tagen)', TextInputType.number, false, intervallController),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
// Datum Text und Button
                    child: _buildWateringDatePicker(dateController),
                  ),
                  Center(
// Bild und Button
                      child: Column(
                          children: [
                              (selectedImage == null)
                                ? Image.asset('assets/wateringCan.png')
                                : Image.file(selectedImage!)
                            ,
                            IconButton(onPressed: getImage, icon: Icon(Icons.camera))

                  ])), // TODO ImagePicker
                  ElevatedButton(
                      onPressed: onSave,

                      child: const Text('Save')),
                ],
              ),
            ),
          ),
        ),
      );
  }

  TextFormField _buildTextField(
    int index,
    String label,
    TextInputType? keyboard,
    bool readOnly,
    TextEditingController controller
  ) {
    return TextFormField(
      maxLines: 1,
      controller: controller,
      key: ValueKey(index),
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboard,
      validator: (value) {
        return formVM.validator(value, label);
      },
    );
  }

  Row _buildWateringDatePicker(TextEditingController controller){
    Intl.defaultLocale = 'en-US';
    String buttonText = 'Datum auswählen';
    if (controller.text.isNotEmpty) buttonText = DateFormat('dd-MM-yyyy').format(DateTime.parse(controller.text));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: Text('Zuletzt Gegossen am')),
        ElevatedButton(
          onPressed: _selectDate,
          child: Text(buttonText),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context as BuildContext,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = pickedDate.toString();
      });
    }
  }

  Future getImage() async {
    final File? image = (await _imagePicker.pickImage(source: ImageSource.camera)) as File?;
    if (image == null) return;
    
    final String originalPath = (await getApplicationDocumentDirectory()).path;
    final String filePath = basename(originalPath);
    // final File imageLocalCopy = await selectedImage.copy(filePath)
    setState(() {
      selectedImage = image;
    });
  }
}

