import 'package:flutter/material.dart';
import 'package:breathband_app/pages/home_page.dart';
import 'package:breathband_app/pages/login_page.dart';
import 'package:breathband_app/pages/register_page.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';

  static final routes = <Route>[
    MaterialPageRoute(builder: (context) => LoginPage()),
    MaterialPageRoute(builder: (context) => RegisterPage()),
    MaterialPageRoute(builder: (context) => HomePage()),
  ];
}