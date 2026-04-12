import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final String status;

  const ReportCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey,
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          ListTile(
            title: Text(title),
            subtitle: Text(description),
            trailing: Text(status),
          ),
        ],
      ),
    );
  }
}
