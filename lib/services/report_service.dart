import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class ReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //  Lire tous les reports
  Stream<List<ReportModel>> getReports() {
    return _db
        .collection('reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReportModel.fromFirestore(doc);
      }).toList();
    });
  }

  //  Ajouter report (pour plus tard)
  Future<void> addReport(ReportModel report) async {
    await _db.collection('reports').add(report.toMap());
  }
  
}