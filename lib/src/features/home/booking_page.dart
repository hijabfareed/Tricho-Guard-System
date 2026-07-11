import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class BookingPage extends StatefulWidget {
  final String doctorId;

  const BookingPage({
    super.key,
    required this.doctorId,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {

  final storage = GetStorage();

  DateTime? selectedDate;
  String? selectedSlot;

  Map<String, dynamic> availabilityMap = {};
  List<String> availableSlots = [];

  @override
  void initState() {
    super.initState();
    loadAvailability();
  }

  /// 🔹 Load doctor availability
  Future<void> loadAvailability() async {

    final snap = await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(widget.doctorId)
        .get();

    print("#################### ${widget.doctorId}");
    print("#################### ${snap.data()}");

    if (!snap.exists) return;

    final data = snap.data()!;

    availabilityMap = {};

    data.forEach((key, value) {

      if (key.startsWith("availability.")) {

        final dateKey =
        key.replaceFirst("availability.", "");

        availabilityMap[dateKey] =
        List<String>.from(value);
      }
    });

    setState(() {});
  }


  /// 🔹 Load slots for selected date
  void loadSlotsForDate(DateTime date) {

    final key = DateFormat("yyyy-MM-dd").format(date);

    if (availabilityMap.containsKey(key)) {
      availableSlots =
      List<String>.from(availabilityMap[key]);
    } else {
      availableSlots = [];
    }

    selectedSlot = null;
    setState(() {});
  }

  /// 🔹 Book Appointment
  Future<void> bookAppointment() async {

    if (selectedDate == null || selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select date & time")),
      );
      return;
    }

    final dateKey =
    DateFormat("yyyy-MM-dd").format(selectedDate!);

    await FirebaseFirestore.instance.collection('booking').add({
      "patientId": storage.read('userid'),
      "doctorId": widget.doctorId,
      "booking_date": dateKey,
      "booking_time": selectedSlot,
      "status": "pending",
      "createdAt": Timestamp.now(),
    });

    /// Remove slot
    await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(widget.doctorId)
        .update({
      "availability.$dateKey":
      FieldValue.arrayRemove([selectedSlot])
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Created")),
    );

    await loadAvailability();
    loadSlotsForDate(selectedDate!);
  }

  /// 🔹 Cancel Booking
  Future<void> cancelBooking(
      String bookingId,
      String date,
      String slot,
      String status,
      ) async {

    if (status == "completed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completed booking cannot be cancelled")),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('booking')
        .doc(bookingId)
        .update({"status": "cancelled"});

    /// Free slot back
    await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(widget.doctorId)
        .update({
      "availability.$date": FieldValue.arrayUnion([slot])
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Cancelled")),
    );
  }

  /// 🔹 Reschedule Booking
  Future<void> rescheduleBooking(
      String bookingId,
      String oldDate,
      String oldSlot,
      String status,
      ) async {

    if (status == "completed") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completed booking cannot be rescheduled")),
      );
      return;
    }

    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      initialDate: DateTime.now(),
    );

    if (picked == null) return;

    final newDateKey =
    DateFormat("yyyy-MM-dd").format(picked);

    if (!availabilityMap.containsKey(newDateKey)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor not available on this date")),
      );
      return;
    }

    final newSlots =
    List<String>.from(availabilityMap[newDateKey]);

    if (newSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No slots available")),
      );
      return;
    }

    final newSlot = newSlots.first; // auto pick first slot

    /// Update booking
    await FirebaseFirestore.instance
        .collection('booking')
        .doc(bookingId)
        .update({
      "booking_date": newDateKey,
      "booking_time": newSlot,
      "status": "pending",
    });

    /// Free old slot
    await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(widget.doctorId)
        .update({
      "availability.$oldDate":
      FieldValue.arrayUnion([oldSlot])
    });

    /// Remove new slot
    await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(widget.doctorId)
        .update({
      "availability.$newDateKey":
      FieldValue.arrayRemove([newSlot])
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking Rescheduled")),
    );
  }

  Color statusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      case "approved":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Booking"),
      child: Column(
        children: [

          /// ================== NEW BOOKING SECTION ==================

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                ElevatedButton(
                  onPressed: () async {

                    DateTime? picked =
                    await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now()
                          .add(const Duration(days: 60)),
                      initialDate: DateTime.now(),
                    );

                    if (picked != null) {
                      selectedDate = picked;
                      loadSlotsForDate(picked);
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? "Select Date"
                        : DateFormat("dd MMM yyyy")
                        .format(selectedDate!),
                  ),
                ),

                const SizedBox(height: 15),

                if (selectedDate != null &&
                    availableSlots.isEmpty)
                  const Text(
                    "Doctor not available on this day",
                    style: TextStyle(color: Colors.red),
                  ),

                if (availableSlots.isNotEmpty)
                  Wrap(
                    spacing: 10,
                    children: availableSlots.map((slot) {

                      final isSelected =
                          selectedSlot == slot;

                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            selectedSlot = slot;
                          });
                        },
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 15),

                if (availableSlots.isNotEmpty)
                  ElevatedButton(
                    onPressed: bookAppointment,
                    child: const Text("Book Appointment"),
                  ),
              ],
            ),
          ),

          const Divider(),

          /// ================== USER BOOKINGS ==================

          const Padding(
            padding: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Bookings",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking')
                  .where('patientId',
                  isEqualTo:
                  storage.read('userid'))
                  .where('doctorId',
                  isEqualTo:
                  widget.doctorId)
                  .orderBy('createdAt',
                  descending: true)
                  .snapshots(),
              builder: (_, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                      child:
                      CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child:
                      Text("No bookings yet"));
                }

                return ListView.builder(
                  itemCount:
                  snapshot.data!.docs.length,
                  itemBuilder: (_, i) {

                    final doc =
                    snapshot.data!.docs[i];
                    final data =
                    doc.data()
                    as Map<String, dynamic>;

                    final status =
                    data['status'];

                    return Card(
                      margin:
                      const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                            "${data['booking_date']} - ${data['booking_time']}"),
                        subtitle: Text(
                          status,
                          style: TextStyle(
                              color:
                              statusColor(status)),
                        ),
                        trailing: status == "completed"
                            ? null
                            : PopupMenuButton(
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: "cancel",
                              child: Text("Cancel"),
                            ),
                            PopupMenuItem(
                              value: "reschedule",
                              child: Text("Reschedule"),
                            ),
                          ],
                          onSelected: (v) {

                            if (v == "cancel") {
                              cancelBooking(
                                doc.id,
                                data['booking_date'],
                                data['booking_time'],
                                status,
                              );
                            } else {
                              rescheduleBooking(
                                doc.id,
                                data['booking_date'],
                                data['booking_time'],
                                status,
                              );
                            }
                          },
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
