import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //  Lire tous les reports
  Stream<List<ReportModel>> getReports() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('reports')
        .where('status', isEqualTo: 'in_progress') // Only admin approved
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .where(
                (doc) => doc['userId'] != currentUserId,
              ) // Hide user's own reports
              .map((doc) => ReportModel.fromFirestore(doc))
              .toList(),
        );
  }

  Stream<List<ReportModel>> getMyReports() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return _db
        .collection('reports')
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromFirestore(doc))
              .toList(),
        );
  }

  //  Ajouter report (pour plus tard)
  Future<void> addReport(ReportModel report) async {
    await _db.collection('reports').add(report.toMap());
  }
}
