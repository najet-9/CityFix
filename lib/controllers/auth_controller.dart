import 'package:cityfix/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //sign up -------------------------------------------------------------------------
  Future signUp(UserModel user, String confirmPassword) async {
    if (user.password != confirmPassword) {
      print('Passwords do not match');
      return;
    }

    // 1. Create user in Firebase Auth
    await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );

    // 2. Save user info to Firestore
    await _db.collection("users").add(user.toJson());
  }

  //log in -------------------------------------------------------------------------
  Future signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  //log out -------------------------------------------------------------------------
  Future signOut() async {
    await _auth.signOut();
  }
}
