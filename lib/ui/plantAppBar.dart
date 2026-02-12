import 'package:flutter/material.dart';

class PlantAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(50);
  final String title = 'Pflanzen';

  PlantAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      toolbarTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
    );
    // TODO: implement build
  }

}