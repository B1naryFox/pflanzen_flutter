import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/ui/viewModels/plantFormViewModel.dart';

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

  late File? selectedImageFile = (widget.plant?.imageUri == null)
      ? null
      : File(widget.plant!.imageUri!);
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
        await formVM.saveImageToPath(selectedImageFile),
      );

      formVM.addPlant(plant);
    } else {
      plant = Plant(
        widget.plant!.id,
        nameController.text,
        standortController.text,
        int.parse(intervallController.text),
        dateController.text,
        await formVM.saveImageToPath(selectedImageFile),
      );
      formVM.updatePlant(plant);
    }
    // Return to Main/Homescreen
    Navigator.pop(this.context);
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
      appBar: PlantAppBar(false),
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
                      // Bild
                      Padding(
                        padding: const EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: (selectedImageFile == null)
                                    ? AssetImage(
                                        'assets/tuska_with_background.png',
                                      )
                                    : FileImage(File(selectedImageFile!.path))
                                          as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Button: Bild aufnemen
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _onImageButtonPressed(ImageSource.camera);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          label: Text(
                            'Bild aufnehmen',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSaveDeleteRow(widget.plant != null)
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
    String dateText = '';
    if (controller.text.isNotEmpty) {
      dateText = DateFormat(
        'dd-MM-yyyy',
      ).format(DateTime.parse(controller.text));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(child: Text('Zuletzt Gegossen am: $dateText')),
        IconButton(
          onPressed: _selectDate,
          icon: Icon(Icons.calendar_month),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: this.context,

      firstDate: DateTime(2025),
      initialDate: DateTime.now(),
      lastDate: DateTime(2027),
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
          selectedImageFile = File(pickedImage.path);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget _buildSaveDeleteRow(bool showDelete) {
    if (showDelete) {
      return Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                  onPressed: (){
                    formVM.deletePlant(widget.plant!);
                    Navigator.pop(this.context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: Text(
                    'Löschen',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
            ),
          ),
          Expanded(
              flex: 2,
              child: saveButton(300)
          )
        ],
      );
    } else {
      return saveButton(double.infinity);
    }
  }

  Widget saveButton(double width) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onSave,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: Text(
          'Speichern',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
      ),
    );
  }
}
