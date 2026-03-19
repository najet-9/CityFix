import 'package:cityfix/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //sign up -------------------------------------------------------------------------
  Future signUp(UserModel user, String confirmPassword) async {
    // validation
    if (user.fullName.isEmpty ||
        user.email.isEmpty ||
        user.password.isEmpty ||
        confirmPassword.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    if (user.password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // 1. Create user in Firebase Auth
    try {
      await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Email is already in use');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'weak-password':
          throw Exception('Password is too weak');
        default:
          throw Exception('Something went wrong. Try again');
      }
    }

    // 2. Save user info to Firestore
    await _db.collection("users").add(user.toJson());
  }

  //log in -------------------------------------------------------------------------
  Future signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Please fill in all fields');
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        //all the three has the same message, so we can group them together
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          throw Exception('Invalid email or password');
        case 'invalid-email':
          throw Exception('Invalid email address');
        default:
          throw Exception('Something went wrong. Try again');
      }
    }
  }

  //log out -------------------------------------------------------------------------
  Future signOut() async {
    await _auth.signOut();
  }

  // Google Sign-In ----------------------------------------------------------------
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }
}

class ProfileController {
  // Simuler une déconnexion
  void signOut() {
    print("Déconnexion de l'utilisateur...");
  }

  // Navigation vers une autre page
  void navigateTo(String route) {
    print("Navigation vers $route");
  }
}
