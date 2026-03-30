import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? reportId;
  final String userId;
  final String category;
  final String imagePath;
  final String description;
  final String location;
  final String status; //  "pending", "in_progress", "resolved"
  final int confirmationCount;
  final Timestamp time;

  ReportModel({
    this.reportId,
    required this.userId,
    required this.category,
    required this.imagePath,
    required this.description,
    required this.location,
    required this.status,
    required this.confirmationCount,
    required this.time,
  });
}
