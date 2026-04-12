import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/report_card.dart';
import 'package:cityfix/screens/language_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class AllReportsScreen extends StatelessWidget {
  const AllReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("All Reports".tr()),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('reports').snapshots(),
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
                title: (data['category'] as String).tr(),
                description: data['description'] ?? "",
                imageUrl: data['imageUrl'] ?? "",
                status: (data['status'] as String).tr(),
              );
            },
          );
        },
      ),
    );
  }
}
