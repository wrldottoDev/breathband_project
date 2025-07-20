import 'dart:async';

class AuthenticationService {
  Future<bool> login(String email, String password) async {
    // Simulate login process
    return Future.delayed(1000, true);
  }

  Future<bool> register(String email, String password) async {
    // Simulate register process
    return Future.delayed(1000, true);
  }
}