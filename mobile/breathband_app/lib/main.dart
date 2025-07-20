import 'package:flutter/material.dart';
import 'package:breathband_app/pages/home_page.dart';
import 'package:breathband_app/pages/login_page.dart';
import 'package:breathband_app/pages/register_page.dart';
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
      routes: <String, WidgetBuilder>{
        Routes.login: (context) => LoginPage(),
        Routes.register: (context) => RegisterPage(),
        Routes.home: (context) => HomePage(),
      },
    );
  }
}