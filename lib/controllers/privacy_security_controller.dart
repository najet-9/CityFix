import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivacySecurityController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future changePassword(String newPassword) async {
    await _auth.currentUser!.updatePassword(newPassword);
  }

  Future deleteAccount() async {
    User? user = _auth.currentUser;

    await _db.collection("users").doc(user!.uid).delete();
    await user.delete();
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
