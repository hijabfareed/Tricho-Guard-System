import 'dart:io';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ExportDataPage extends StatefulWidget {
  const ExportDataPage({super.key});

  @override
  State<ExportDataPage> createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {

  final storage = GetStorage();
  bool isLoading = false;

  /// ================= EXPORT PDF =================

  Future<void> exportAsPDF() async {

    setState(() => isLoading = true);

    final uid = storage.read('userid');

    final bookings = await FirebaseFirestore.instance
        .collection('booking')
        .where('patientId', isEqualTo: uid)
        .get();

    final aiReports = await FirebaseFirestore.instance
        .collection('ai_predictions')
        .where('userId', isEqualTo: uid)
        .get();

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [

          pw.Text(
            "Health Report",
            style: pw.TextStyle(fontSize: 22),
          ),

          pw.SizedBox(height: 20),

          pw.Text("Bookings:"),

          ...bookings.docs.map((doc) {
            return pw.Text(
                "• ${doc['booking_date']} - ${doc['booking_time']} (${doc['status']})"
            );
          }),

          pw.SizedBox(height: 20),

          pw.Text("AI Reports:"),

          ...aiReports.docs.map((doc) {
            return pw.Text(
                "• ${doc['aiLabel']} (Confidence: ${doc['aiConfidence']})"
            );
          }),

        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/health_report.pdf");

    await file.writeAsBytes(await pdf.save());

    setState(() => isLoading = false);

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "health_report.pdf",
    );
  }

  /// ================= EXPORT CSV =================

  Future<void> exportAsCSV() async {

    setState(() => isLoading = true);

    final uid = storage.read('userid');

    final bookings = await FirebaseFirestore.instance
        .collection('booking')
        .where('patientId', isEqualTo: uid)
        .get();

    String csv = "Date,Time,Status\n";

    for (var doc in bookings.docs) {
      csv += "${doc['booking_date']},${doc['booking_time']},${doc['status']}\n";
    }

    final dir = await getTemporaryDirectory();
    final file = File("${dir.path}/booking_history.csv");

    await file.writeAsString(csv);

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("CSV file generated successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Export Health Data"),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff407CE2),
                    Color(0xff6AA9FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  Icon(Icons.download, color: Colors.white, size: 30),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Download your health history for personal or clinical use.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff407CE2),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: exportAsPDF,
              child: const Text("Export as PDF"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: exportAsCSV,
              child: const Text("Export as CSV"),
            ),

            const SizedBox(height: 30),

            if (isLoading)
              const CircularProgressIndicator(),

          ],
        ),
      ),
    );
  }
}
