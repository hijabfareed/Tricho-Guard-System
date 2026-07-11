import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminSystemStatusPage extends StatelessWidget {
  const AdminSystemStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text("System Status"),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .orderBy('lastActiveAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = users[index].data() as Map<String, dynamic>;
              final bool isOnline = data['isOnline'] ?? false;
              final Timestamp? lastActive = data['lastActiveAt'];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Theme.of(context).cardColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    /// STATUS DOT
                    CircleAvatar(
                      radius: 6,
                      backgroundColor:
                      isOnline ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 12),

                    /// USER INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            data['email'] ?? '',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "Role: ${data['role']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    /// LAST ACTIVE
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isOnline ? "ONLINE" : "OFFLINE",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isOnline ? Colors.green : Colors.red,
                          ),
                        ),
                        if (lastActive != null)
                          Text(
                            DateFormat('hh:mm a')
                                .format(lastActive.toDate()),
                            style: const TextStyle(fontSize: 12),
                          ),
                      ],
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
