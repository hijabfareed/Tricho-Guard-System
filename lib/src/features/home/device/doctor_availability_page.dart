import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DoctorAvailabilityPage extends StatefulWidget {
  const DoctorAvailabilityPage({super.key});

  @override
  State<DoctorAvailabilityPage> createState() =>
      _DoctorAvailabilityPageState();
}

class _DoctorAvailabilityPageState
    extends State<DoctorAvailabilityPage> {

  final storage = GetStorage();

  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  List<String> generatedSlots = [];

  /// 🔹 Generate 30 min slots
  void generateSlots() {

    if (startTime == null || endTime == null) return;

    generatedSlots.clear();

    DateTime start = DateTime(
      0, 0, 0,
      startTime!.hour,
      startTime!.minute,
    );

    DateTime end = DateTime(
      0, 0, 0,
      endTime!.hour,
      endTime!.minute,
    );

    while (start.isBefore(end)) {
      generatedSlots.add(
        DateFormat("hh:mm a").format(start),
      );
      start = start.add(const Duration(minutes: 30));
    }

    setState(() {});
  }

  /// 🔹 Save to Firestore
  Future<void> saveAvailability() async {

    if (selectedDate == null ||
        generatedSlots.isEmpty) {

      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.red,
        title: "Error",
        message: "Select date & time",
      );
      return;
    }

    final uid = storage.read('userid');

    final dateKey =
    DateFormat("yyyy-MM-dd")
        .format(selectedDate!);

    await FirebaseFirestore.instance
        .collection('doctor_availability')
        .doc(uid)
        .set({
      "availability.$dateKey":
      generatedSlots,
      "updatedAt": Timestamp.now(),
    }, SetOptions(merge: true));

    CommonSnackBar.getSnackBar(
      backgroundColor: Colors.green,
      title: "Success",
      message: "Availability Saved",
    );

    generatedSlots.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Set Availability"),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 📅 DATE PICKER
            ListTile(
              leading: const Icon(Icons.date_range),
              title: Text(
                selectedDate == null
                    ? "Select Date"
                    : DateFormat("dd MMM yyyy")
                    .format(selectedDate!),
              ),
              onTap: () async {

                DateTime? picked =
                await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now()
                      .add(const Duration(days: 60)),
                  initialDate: DateTime.now(),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            /// ⏰ START TIME
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                startTime == null
                    ? "Select Start Time"
                    : startTime!.format(context),
              ),
              onTap: () async {

                final picked =
                await showTimePicker(
                  context: context,
                  initialTime:
                  TimeOfDay.now(),
                );

                if (picked != null) {
                  setState(() {
                    startTime = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            /// ⏰ END TIME
            ListTile(
              leading: const Icon(Icons.access_time),
              title: Text(
                endTime == null
                    ? "Select End Time"
                    : endTime!.format(context),
              ),
              onTap: () async {

                final picked =
                await showTimePicker(
                  context: context,
                  initialTime:
                  TimeOfDay.now(),
                );

                if (picked != null) {
                  setState(() {
                    endTime = picked;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            /// 🔥 GENERATE BUTTON
            ElevatedButton(
              onPressed: generateSlots,
              child: const Text("Generate 30min Slots"),
            ),

            const SizedBox(height: 20),

            /// 🔹 Preview Slots
            if (generatedSlots.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  itemCount: generatedSlots.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (_, i) {

                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                        const Color(0xff407CE2),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Text(
                        generatedSlots[i],
                        style: const TextStyle(
                            color: Colors.white),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),

            /// 💾 SAVE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xff407CE2)),
                onPressed: saveAvailability,
                child: const Text("Save Availability"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
