import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:table_calendar/table_calendar.dart';

class DoctorCalendarPage extends StatefulWidget {
  const DoctorCalendarPage({super.key});

  @override
  State<DoctorCalendarPage> createState() =>
      _DoctorCalendarPageState();
}

class _DoctorCalendarPageState
    extends State<DoctorCalendarPage> {

  final storage = GetStorage();

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  Widget build(BuildContext context) {

    final doctorId =
    storage.read('userid');

    return CommonScaffold(
      withAppBar: true,
      title:
      const Text("Booking Calendar"),
      child: Column(
        children: [

          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            selectedDayPredicate:
                (day) =>
                isSameDay(
                    selectedDay, day),
            onDaySelected:
                (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
            },
          ),

          const SizedBox(height: 20),

          Expanded(
            child:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore
                  .instance
                  .collection('booking')
                  .where('doctorId',
                  isEqualTo: doctorId)
                  .snapshots(),
              builder: (_, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(
                      child:
                      CircularProgressIndicator());
                }

                final bookings =
                snapshot.data!.docs
                    .where((doc) {

                  final data =
                  doc.data()
                  as Map<
                      String,
                      dynamic>;

                  if (selectedDay ==
                      null)
                    return false;

                  final dateString =
                      "${selectedDay!.day}/${selectedDay!.month}/${selectedDay!.year}";

                  return data[
                  'booking_date'] ==
                      dateString;
                }).toList();

                if (bookings.isEmpty) {
                  return const Center(
                      child: Text(
                          "No bookings for this day"));
                }

                return ListView.builder(
                  itemCount:
                  bookings.length,
                  itemBuilder:
                      (_, i) {

                    final data =
                    bookings[i]
                        .data()
                    as Map<
                        String,
                        dynamic>;

                    return ListTile(
                      title: Text(
                          data[
                          'booking_time']),
                      subtitle:
                      Text(data[
                      'status']),
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
