import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySecurityController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // --- CHANGEMENT DE MOT DE PASSE ---
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
      } else {
        throw "No user found";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw "Security: Please logout and login again to change password.";
      }
      throw e.message ?? "An error occurred";
    }
  }

  // SUPPRESSION DE COMPTE  
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // 1. Supprimer les données dans Firestore d'abord 
        await _db.collection("users").doc(uid).delete();

        // 2. Nettoyage des préférences locales 
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // 3. Déconnexion de Google si nécessaire
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
          await _googleSignIn.disconnect();
        }

        // 4. Suppression définitive du compte Firebase Authentication
        await user.delete();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw "requires-recent-login"; // Sera capturé par l'UI pour afficher l'alerte
      }
      rethrow;
    }
  }

  // DÉCONNEXION
  Future<void> signOut() async {
    try {
      // 1. Nettoyage OneSignal dans Firestore (optionnel mais recommandé)
      if (_auth.currentUser != null) {
        await _db.collection('users').doc(_auth.currentUser!.uid).update({
          'oneSignalId': null,
        });
      }

      // 2. Nettoyage SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Déconnexion Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }

      // 4. Déconnexion Firebase
      await _auth.signOut();
    } catch (e) {
      print("Error during signOut: $e");
      await _auth.signOut(); // Force la sortie même en cas d'erreur
    }
  }
}