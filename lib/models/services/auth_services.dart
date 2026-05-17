import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static User? get user => FirebaseAuth.instance.currentUser;

  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

  static String? get email => FirebaseAuth.instance.currentUser?.email;
}
