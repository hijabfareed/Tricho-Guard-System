import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class DoctorBookingPage extends StatefulWidget {
  const DoctorBookingPage({super.key});

  @override
  State<DoctorBookingPage> createState() => _DoctorBookingPageState();
}

class _DoctorBookingPageState extends State<DoctorBookingPage> {
  final storage = GetStorage();

  Color statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.blue;
      case "completed":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "cancelled":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  Future<void> updateStatus(
    String bookingId,
    String patientId,
    String status,
    String bookingTime,
  ) async {
    final doctorId = storage.read('userid');

    /// ✅ Prevent approving already approved slot
    if (status == "approved") {
      final check = await FirebaseFirestore.instance
          .collection('booking')
          .where('doctorId', isEqualTo: doctorId)
          .where('booking_time', isEqualTo: bookingTime)
          .where('status', isEqualTo: "approved")
          .get();

      if (check.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Slot already approved"),
          ),
        );
        return;
      }

      /// 🔒 Remove slot from availability
      await FirebaseFirestore.instance.collection('doctor_availability').doc(doctorId).update({
        "isReviewed" : false,
        "slots": FieldValue.arrayRemove([bookingTime])
      });
    }

    /// 🔓 Free slot if rejected or cancelled
    if (status == "rejected" || status == "cancelled") {
      await FirebaseFirestore.instance.collection('doctor_availability').doc(doctorId).update({
        "slots": FieldValue.arrayUnion([bookingTime])
      });
    }

    await FirebaseFirestore.instance.collection('booking').doc(bookingId).update({"status": status});

    /// 🔔 Send notification to patient
    await FirebaseFirestore.instance.collection('notifications').add({
      "patientId": patientId,
      "title": "Booking Update",
      "message": "Your booking has been $status",
      "isRead": false,
      "createdAt": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = storage.read('userid');

    return CommonScaffold(
      withAppBar: true,
      title: const Text("My Bookings"),
      child: Column(
        children: [
          /// 📅 Calendar Button
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff407CE2),
              ),
              onPressed: () {
                getIt<NavigationService>().navigateTo(NavigationPath.doctorCalendarPage);
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text("Open Calendar View"),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking')
                  .where('doctorId', isEqualTo: doctorId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No bookings"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    final status = data['status'];

                    return Card(
                      margin: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// 👤 Patient Name
                            FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('Users').doc(data['patientId']).get(),
                              builder: (_, snap) {
                                if (!snap.hasData) {
                                  return const Text("Loading...");
                                }

                                final patient = snap.data!.data() as Map<String, dynamic>;

                                return Text(
                                  "Patient: ${patient['name'] ?? "Unknown"}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                );
                              },
                            ),

                            const SizedBox(height: 6),

                            Text("Date: ${data['booking_date']}"),

                            Text("Time: ${data['booking_time']}"),

                            const SizedBox(height: 6),

                            Text(
                              "Status: $status",
                              style: TextStyle(
                                color: statusColor(status),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            if (status == "pending")
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () {
                                      updateStatus(doc.id, data['patientId'], "approved", data['booking_time']);
                                    },
                                    child: const Text("Accept"),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    onPressed: () {
                                      updateStatus(doc.id, data['patientId'], "rejected", data['booking_time']);
                                    },
                                    child: const Text("Reject"),
                                  ),
                                ],
                              ),

                            if (status == "approved")
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                onPressed: () {
                                  updateStatus(doc.id, data['patientId'], "completed", data['booking_time']);
                                },
                                child: const Text("Mark Completed"),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
