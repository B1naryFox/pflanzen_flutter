import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

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
  late final TextEditingController nameController = TextEditingController(
    text: widget.plant?.name,
  );
  late final TextEditingController standortController = TextEditingController(
    text: widget.plant?.standort,
  );
  late final TextEditingController intervallController = TextEditingController(
    text: widget.plant?.giessintervall.toString(),
  );
  late final TextEditingController dateController = TextEditingController(
    text: widget.plant?.zuletztGegossenDatum,
  );

  late XFile? selectedImageFile = (widget.plant?.imageUri == null) ? null : XFile(widget.plant!.imageUri!);
  final ImagePicker _imagePicker = ImagePicker();


  final GlobalKey<FormState> _formKey = GlobalKey();
  final PlantFormViewModel formVM = PlantFormViewModel();

  // Speicherung/Update einer Pflanze
  Future<void> onSave() async {
    final bool isValid =
        _formKey.currentState?.validate() ??
        false; // Validierung der Text Felder
    if (!isValid) return;

    Plant plant;
    if (widget.plant == null) {
      plant = Plant.newId(
        nameController.text,
        standortController.text,
        int.parse(intervallController.text),
        dateController.text,
        await _persistImage()
      );

      formVM.addPlant(plant);

    } else {
      plant = Plant(
        widget.plant!.id,
        nameController.text,
        standortController.text,
        int.parse(intervallController.text),
        dateController.text,
        await _persistImage()
      );
      formVM.updatePlant(plant);
    }
    // Return to Main/Homescreen
    Navigator.pop(context as BuildContext);
  }

  @override
  void dispose() {
    nameController.dispose();
    standortController.dispose();
    intervallController.dispose();
    dateController.dispose();
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
                _buildTextField(
                  0,
                  'Name',
                  TextInputType.name,
                  false,
                  nameController,
                ),
                _buildTextField(
                  1,
                  'Standort',
                  TextInputType.name,
                  false,
                  standortController,
                ),
                _buildTextField(
                  2,
                  'Gießintervall (in Tagen)',
                  TextInputType.number,
                  false,
                  intervallController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  // Datum Text und Button
                  child: _buildWateringDatePicker(dateController),
                ),
                Center(
                  // Bild und Button
                  child: Column(
                    children: [
                      Image(
                       image: (selectedImageFile == null)
                            ? AssetImage('assets/tuska_with_background.png')
                            : FileImage(File(selectedImageFile!.path)) as ImageProvider,
                        width: 300,
                        height: 300,
                      ),
                      IconButton(
                        onPressed: () {
                          _onImageButtonPressed(ImageSource.camera);
                        },
                        icon: Icon(Icons.camera),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(onPressed: onSave, child: const Text('Speichern')),
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
    TextEditingController controller,
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

  Row _buildWateringDatePicker(TextEditingController controller) {
    Intl.defaultLocale = 'en-US';
    String buttonText = 'Datum auswählen';
    if (controller.text.isNotEmpty) {
      buttonText = DateFormat(
        'dd-MM-yyyy',
      ).format(DateTime.parse(controller.text));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Text('Zuletzt Gegossen am')),
        ElevatedButton(onPressed: () {
          print("showing date picker");
          _selectDate;
          }, child: Text(buttonText)),
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

  Future<void> _onImageButtonPressed(ImageSource imageSource) async {
    try {
      final XFile? pickedImage = await _imagePicker.pickImage(
        source: imageSource,
      );
      setState(() {
        if (pickedImage != null) {
          selectedImageFile = pickedImage;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String?> _persistImage() async {
    String? imagePath;
    if (selectedImageFile != null) {
      final String dirPath = (await getApplicationDocumentsDirectory()).path;
      final String fileName = basename(selectedImageFile!.path);
      imagePath = '$dirPath/$fileName';
      await selectedImageFile!.saveTo(imagePath);
    }
    return imagePath;
  }
}
