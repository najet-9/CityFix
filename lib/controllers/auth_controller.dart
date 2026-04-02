import 'package:cityfix/models/user_model.dart';
import 'package:cityfix/screens/alerts_screen.dart';
import 'package:cityfix/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //sign up -------------------------------------------------------------------------
  Future signUp(UserModel user, String confirmPassword) async {
    // validation
    if (user.fullName.isEmpty ||
        user.email.isEmpty ||
        user.password.isEmpty ||
        user.phoneNumber.isEmpty ||
        user.wilaya.isEmpty ||
        confirmPassword.isEmpty) {
      throw Exception('Please fill in all fields');
    }

    if (user.password != confirmPassword) {
      throw Exception('Passwords do not match');
    }

    // 1. Create user in Firebase Auth + Save to Firestore
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      // Save user info to Firestore using UID as document ID
      await _db.collection("users").doc(cred.user!.uid).set(user.toJson());
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    cachedUserName = null;
    await _auth.signOut();
  }

  //get username -------------------------------------------------------------------------
  static String? cachedUserName;

  Future<String> getUserName() async {
    // 1. return cached memory value if available
    if (cachedUserName != null) return cachedUserName!;

    // 2. try to get from local storage first (instant)
    final prefs = await SharedPreferences.getInstance();
    final localName = prefs.getString('userName');
    if (localName != null) {
      cachedUserName = localName;
      return cachedUserName!;
    }

    // 3. only if not found locally, fetch from Firestore
    final uid = _auth.currentUser!.uid;
    final doc = await _db.collection('users').doc(uid).get();
    cachedUserName = doc.data()?['fullName'] ?? 'User';

    // 4. save to local storage for next time
    await prefs.setString('userName', cachedUserName!);

    return cachedUserName!;
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
