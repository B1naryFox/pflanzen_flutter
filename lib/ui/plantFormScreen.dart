import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pflanzen_flutter/data/plant.dart';
import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/ui/plantFormViewModel.dart';

class PlantFormScreen extends StatefulWidget {
  final Plant? plant;

  const PlantFormScreen({super.key, this.plant});

  @override
  State<PlantFormScreen> createState() => _PlantFormState();
}

class _PlantFormState extends State<PlantFormScreen> {

  late final TextEditingController nameController = TextEditingController(text: widget.plant?.name);
  late final TextEditingController standortController = TextEditingController(text: widget.plant?.standort);
  late final TextEditingController intervallController = TextEditingController(text: widget.plant?.giessintervall.toString());
  late final TextEditingController dateController = TextEditingController(text: widget.plant?.zuletztGegossenDatum);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final PlantFormViewModel formVM = PlantFormViewModel();

  Future<void> onSave() async {
    final bool isValid = _formKey.currentState?.validate() ?? false; // Validate TextFields
    if (!isValid) return;
    var plant = Plant.newId(nameController.text, standortController.text, int.parse(intervallController.text), dateController.text);
    formVM.addPlant(plant);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PlantAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(0, 'Name', TextInputType.name, false, nameController),
                  _buildTextField(1, 'Standort', TextInputType.name, false, standortController),
                  _buildTextField(2, 'Gießintervall (in Tagen)', TextInputType.number, false, intervallController),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: _buildWateringDatePicker(dateController),
                  ),
                  Center(child: Column(children: [

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
        return validator(value, label);
      },
    );
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
      context: context,
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
}

