import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? reportId;
  final String userId;
  final String category;
  final String imageUrl;
  final String description;
  final GeoPoint location;
  final String status; //  "pending", "in_progress", "resolved"
  final int confirmationCount;

  ReportModel({
    this.reportId,
    required this.userId,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.location,
    this.status = "pending",
    this.confirmationCount = 0,
  });
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
      'location': location,
      'status': status,
      'confirmationCount': confirmationCount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
