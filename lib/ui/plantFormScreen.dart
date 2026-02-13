import 'package:flutter/material.dart';
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
    var plant = Plant(8, nameController.text, standortController.text, int.parse(intervallController.text), DateTime.now().toString());
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: Text('Zuletzt Gegossen am')),
                      ElevatedButton(
                        onPressed: () {}, // TODO datepicker
                        child: Text('Datum auswählen'),
                      ),
                    ],
                  ),
                  Center(child: Column(children: [])),
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
}
