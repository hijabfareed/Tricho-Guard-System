import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DoctorAlertPage extends StatefulWidget {
  const DoctorAlertPage({super.key});

  @override
  State<DoctorAlertPage> createState() => _DoctorAlertPageState();
}

class _DoctorAlertPageState extends State<DoctorAlertPage> {
  final storage = GetStorage();

  String? selectedPatientId;
  String selectedReason = "General Advice";

  final TextEditingController messageController = TextEditingController();

  final List<String> reasons = [
    "General Advice",
    "Follow-up Required",
    "Medication Reminder",
    "Urgent Attention",
    "Test Required",
  ];

  Future<void> sendAlert() async {
    if (selectedPatientId == null || messageController.text.isEmpty) {
      CommonSnackBar.getSnackBar(
        title: "Missing Info",
        message: "Select patient & write message",
        backgroundColor: Colors.red,
      );
      return;
    }

    final doctorId = storage.read('userid');

    final doctorDoc = await FirebaseFirestore.instance
        .collection('dermatologists') // 👈 correct collection
        .doc(doctorId)
        .get();

    final doctorName = doctorDoc['name'] ?? "Doctor";

    await FirebaseFirestore.instance.collection('doctor_alerts').add({
      "doctorId": doctorId,
      "doctorName": doctorName,
      "patientId": selectedPatientId,
      "title": selectedReason,
      "message": messageController.text.trim(),
      "reason": selectedReason,
      "createdAt": Timestamp.now(),
      "isRead": false,
    });

    /// Also push notification
    await FirebaseFirestore.instance.collection('notifications').add({
      "patientId": selectedPatientId,
      "title": "Doctor Alert",
      "message": messageController.text.trim(),
      "isRead": false,
      "createdAt": Timestamp.now(),
    });

    CommonSnackBar.getSnackBar(
      title: "Success",
      message: "Alert sent successfully",
      backgroundColor: Colors.green,
    );

    messageController.clear();
    setState(() {
      selectedPatientId = null;
      selectedReason = reasons.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text("Send Alert"),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Patient",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('booking')
                    .where('doctorId',
                    isEqualTo: storage.read('userid'))
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final bookings = snapshot.data!.docs;

                  final patientIds = bookings
                      .map((e) => e['patientId'])
                      .toSet()
                      .toList();

                  if (patientIds.isEmpty) {
                    return const Text("No patients yet");
                  }

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .where(FieldPath.documentId,
                        whereIn: patientIds)
                        .get(),
                    builder: (context, userSnapshot) {

                      if (!userSnapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      final users = userSnapshot.data!.docs;

                      return DropdownButtonFormField<String>(
                        value: selectedPatientId,
                        items: users
                            .map<DropdownMenuItem<String>>(
                                (doc) {
                              final data =
                              doc.data() as Map<String, dynamic>;

                              return DropdownMenuItem<String>(
                                value: doc.id,
                                child: Text(
                                    data['name'] ?? "Patient"),
                              );
                            }).toList(),
                        onChanged: (v) {
                          setState(() {
                            selectedPatientId = v;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Reason",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedReason,
                items: reasons
                    .map((reason) => DropdownMenuItem(
                          value: reason,
                          child: Text(reason),
                        ))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedReason = v!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Message",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Write alert message...",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: CommonButton(
                  title: "Send Alert",
                  onTap: sendAlert,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
