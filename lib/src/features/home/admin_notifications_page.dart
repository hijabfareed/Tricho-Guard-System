import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/features/controller/admin_notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = AdminNotificationController();

    return CommonScaffold(
      withAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddNotification(context, controller),
        child: const Icon(Icons.add),
      ),
      title: const Text("Admin Notifications"),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AdminNotifications')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              final time = (data['createdAt'] as Timestamp).toDate();

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 14,
                  ),
                  title: Text(
                    data['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${data['message']}\n${DateFormat('hh:mm a • dd MMM').format(time)}",
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('AdminNotifications')
                          .doc(doc.id)
                          .update({"isRead": true});
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _openAddNotification(
      BuildContext context,
      AdminNotificationController controller,
      ) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    String target = 'all';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Notification",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 8),

              TextField(
                controller: msgCtrl,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Message"),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: target,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text("All Users")),
                  DropdownMenuItem(value: 'patient', child: Text("Patients")),
                  DropdownMenuItem(value: 'doctor', child: Text("Doctors")),
                ],
                onChanged: (v) => target = v!,
                decoration: const InputDecoration(labelText: "Target"),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  await controller.addNotification(
                    title: titleCtrl.text,
                    message: msgCtrl.text,
                    target: target,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Send Notification"),
              ),
            ],
          ),
        );
      },
    );
  }



}
