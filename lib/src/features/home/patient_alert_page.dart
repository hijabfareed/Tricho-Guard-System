import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class PatientAlertPage extends StatefulWidget {
  const PatientAlertPage({super.key});

  @override
  State<PatientAlertPage> createState() => _PatientAlertPageState();
}

class _PatientAlertPageState extends State<PatientAlertPage> {
  final storage = GetStorage();

  Future<String> getDoctorName(String doctorId) async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(doctorId).get();

    if (!doc.exists) return "Doctor";

    return doc['name'] ?? "Doctor";
  }

  @override
  Widget build(BuildContext context) {
    final patientId = storage.read('userid');

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Doctor Alerts"),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctor_alerts')
            .where('patientId', isEqualTo: patientId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No alerts yet"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              final doc = snapshot.data!.docs[index];

              final data = doc.data() as Map<String, dynamic>;

              final time = (data['createdAt'] as Timestamp).toDate();

              /// mark read
              if (data['isRead'] == false) {
                doc.reference.update({"isRead": true});
              }

              return FutureBuilder<String>(
                future: getDoctorName(data['doctorId']),
                builder: (context, doctorSnap) {
                  final doctorName = doctorSnap.data ?? "Doctor";

                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctorName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['reason'] ?? "",
                                  style: const TextStyle(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Alert",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          data['message'] ?? "",
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          DateFormat("dd MMM yyyy • hh:mm a").format(time),
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
