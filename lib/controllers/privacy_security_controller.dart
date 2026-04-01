import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacySecurityController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw "No user found";
      }
    } on FirebaseAuthException catch (e) {
      // Erreur fréquente : l'utilisateur doit se reconnecter pour changer son MDP
      if (e.code == 'requires-recent-login') {
        throw "Security: Please logout and login again to change password.";
      }
      throw e.message ?? "An error occurred";
    }
  }

  Future<void> deleteAccount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _db.collection("users").doc(user.uid).delete();
      await user.delete();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}