import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDoctorRatingsPage extends StatelessWidget {
  const AdminDoctorRatingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text("Doctor Ratings"),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctor_ratings')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No ratings yet"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
              docs[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(
                    data['doctorName'] ?? 'Doctor',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _stars(data['rating']),
                      if ((data['comment'] ?? '').toString().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            data['comment'],
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                    ],
                  ),
                  trailing: Text(
                    DateFormat('dd MMM')
                        .format((data['createdAt'] as Timestamp).toDate()),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _stars(int rating) {
    return Row(
      children: List.generate(
        5,
            (i) => Icon(
          Icons.star,
          size: 16,
          color: i < rating ? Colors.amber : Colors.grey.shade300,
        ),
      ),
    );
  }
}
