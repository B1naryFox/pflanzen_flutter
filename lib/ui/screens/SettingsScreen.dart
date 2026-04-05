import 'package:flutter/material.dart';

import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/data/SharedPrefService.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  late Sorting sort;
  late TimeOfDay time;

  @override
  void initState() {
    super.initState();
    var index = SharedPrefService.getSortIndex();
    sort = Sorting.values[index ?? 0];

    var (hour, minute) = SharedPrefService.getNotificationTime();
    time = TimeOfDay(hour: hour ?? 8, minute: minute ?? 0);
    print('init state completed');
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlantAppBar(false),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          TextButton(onPressed: _showSortingOpt, child: Text('Sortierreihenfolge: ${sort.title}')),
          TextButton(onPressed: _showTimePicker, child: Text('Benachrichtigungszeit: ${time}')),
          TextButton(onPressed: _saveToPref, child: Text('Save to Preferences'))
        ],
      ),
    );
  }

  void _showSortingOpt(){
    SimpleDialog sortOpt = SimpleDialog(
      title: Text('Sortierreihenfolge'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: (){
            setState(() {
              sort = Sorting.NAME;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(Sorting.NAME.title),),

        SimpleDialogOption(
          onPressed: (){
            setState(() {
              sort = Sorting.GIESSDATUM;
            });
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(Sorting.GIESSDATUM.title),)
      ],);

    showDialog(context: this.context, builder: (BuildContext context){
      return sortOpt;
    });
  }

  Future<void> _showTimePicker() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: this.context,
      initialTime: time,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      orientation: Orientation.portrait,
    );
    if (pickedTime == null) return ;
    setState(() {
      time = pickedTime;
    });
  }

  void _saveToPref(){
    SharedPrefService.setSort(sort.index);
    SharedPrefService.setNotificationTime(time.hour, time.minute);
  }
}