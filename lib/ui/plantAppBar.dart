import 'package:flutter/material.dart';
import 'package:pflanzen_flutter/ui/screens/SettingsScreen.dart';

class PlantAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(50);
  final String title = 'Pflanzen';
  final bool showSettingsButton;

  PlantAppBar(this.showSettingsButton, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [?settingsButton(showSettingsButton, context)],
      automaticallyImplyLeading: false,
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      toolbarTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    );
  }

  Widget? settingsButton(bool show, context){
    if (show == false) return null;
    return IconButton(onPressed: (){navigateToSettings(context);}, icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onPrimary,));
  }

  void navigateToSettings(context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Settingsscreen()));
  }

}
