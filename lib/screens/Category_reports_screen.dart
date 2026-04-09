import 'package:flutter/material.dart';
import 'package:cityfix/models/report_model.dart';
import 'package:cityfix/services/report_service.dart';
import 'package:cityfix/screens/report_detail_screen.dart';
import 'package:cityfix/screens/language_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoryReportsScreen extends StatelessWidget {
  final String category;
  final ReportService _reportService = ReportService();

  CategoryReportsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(
          "$category Reports.tr()"),
        backgroundColor: const Color(0xFF2B58E4),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: StreamBuilder<List<ReportModel>>(
        // On récupère tous les rapports et on filtre par catégorie
        stream: _reportService.getReports(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filtrage local des rapports par catégorie
          final reports = snapshot.data?.where((r) => 
            category == "All".tr() ? true : r.category.toLowerCase() == category.toLowerCase()
          ).toList() ?? [];

          if (reports.isEmpty) {
            return Center(child: Text("No reports found for this category.".tr()));
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: reports.length,
            itemBuilder: (context, index) => _buildReportCard(context, reports[index]),
          );
        },
      ),
    );
  }

  // Réutilisation de ton design de carte (simplifié pour l'exemple)
  Widget _buildReportCard(BuildContext context, ReportModel report) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportDetailScreen(reportId: report.reportId!)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(report.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
            ),
            ListTile(
              title: Text(report.category.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(report.description, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text("👍 ${report.confirmationCount}"),
            ),
          ],
        ),
      ),
    );
  }
}