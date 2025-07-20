import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;

Future<User?> createUser(String email, String password) async {
  try {
    final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    print(e.message);
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}