import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static User? get user => FirebaseAuth.instance.currentUser;

  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

  static String? get email => FirebaseAuth.instance.currentUser?.email;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(AuthService.uid)
        .snapshots();
  }
}
