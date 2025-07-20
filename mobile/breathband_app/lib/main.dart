import 'package:flutter/material.dart';
import 'package:breathband_app/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: Routes.login,
      routes: Routes.routeMap,
    );
  }
}