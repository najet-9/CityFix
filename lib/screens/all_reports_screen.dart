import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/report_card.dart';

class AllReportsScreen extends StatelessWidget {
  const AllReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Reports"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final data = reports[index];

              return ReportCard(
                title: data['category'] ?? "",
                description: data['description'] ?? "",
                imageUrl: data['imageUrl'] ?? "",
                status: data['status'] ?? "",
              );
            },
          );
        },
      ),
    );
  }
}