

import 'package:flutter/material.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback  onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
          icon
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}
