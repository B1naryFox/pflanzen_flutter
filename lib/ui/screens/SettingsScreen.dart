import 'package:flutter/material.dart';
import 'package:pflanzen_flutter/data/NotificationService.dart';

import 'package:pflanzen_flutter/ui/plantAppBar.dart';
import 'package:pflanzen_flutter/data/SharedPrefService.dart';
import 'package:pflanzen_flutter/ui/viewModels/mainViewModel.dart';

class Settingsscreen extends StatefulWidget {
  const Settingsscreen({super.key});

  @override
  State<Settingsscreen> createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  late Sorting sort;
  late TimeOfDay? time;

  @override
  void initState() {
    super.initState();
    var index = SharedPrefService.getSortIndex();
    sort = Sorting.values[index ?? 0];

    var (hour, minute) = SharedPrefService.getNotificationTime();
    if (hour != null) {
      time = TimeOfDay(hour: hour, minute: minute ?? 0);
    }else{
      time = TimeOfDay(hour: 0, minute: 0);
    }

  }

  @override
  void dispose() {
    MainViewModel().fetchPlants();
    time = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PlantAppBar(false),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(onPressed: _showSortingOpt, child: Text('Sortierreihenfolge: ${sort.title}')),
          TextButton(onPressed: _showTimePicker, child: Text('Benachrichtigungszeit: ${time ?? 'einstellen'}')),

        ],
      ),
    );
  }

//TextButton(onPressed: _saveToPref, child: Text('Save to Preferences'))

  void _showSortingOpt(){
    SimpleDialog sortOpt = SimpleDialog(
      title: Text('Sortierreihenfolge'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: (){
            setState(() {
              sort = Sorting.NAME;
            });
            SharedPrefService.setSort(sort.index);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text(Sorting.NAME.title),),

        SimpleDialogOption(
          onPressed: (){
            setState(() {
              sort = Sorting.GIESSDATUM;
            });
            SharedPrefService.setSort(sort.index);
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
      initialTime: time ?? TimeOfDay(hour: 8, minute: 0),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      orientation: Orientation.portrait,
    );
    if (pickedTime == null || pickedTime == time) return ;
    NotificationService.canceledNotification();
    setState(() {
      time = pickedTime;
      SharedPrefService.setNotificationTime(time!.hour, time!.minute);
      NotificationService.scheduleNotification(time: time!);
    });
  }
}