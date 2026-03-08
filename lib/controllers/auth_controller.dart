import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  //1 method for signing up a user================================================================
  Future signUp(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    // Check if passwords match
    if (password != confirmPassword) {
      print('Passwords do not match');
      return; //if they don't match we return and do not proceed to firebase
    }

    // Create user in Firebase
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //2 method for signing in a user=================================================================

  //this method will return something in the future so we use Future
  Future signIn(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //3 method for signing out a user================================================================
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
