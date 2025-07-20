import 'package:flutter/material.dart';

const double _kHeight = 50.0;

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(_kHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('BreathBand App'),
    );
  }
}