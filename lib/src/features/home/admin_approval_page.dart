import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({super.key});

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Dermatologist Approvals",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dermatologists')
            .where('approvalStatus', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No pending approvals"),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final docId = doc.id;

              final DateTime licenseTo =
              (data['licenseTo'] as Timestamp).toDate();

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 👤 HEADER (AVATAR + NAME)
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor:
                            AppColors.primaryColorBlue.withOpacity(0.15),
                            child: Text(
                              (data['name'] ?? 'D')
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColorBlue,
                              ),
                            ),
                          ),
                          14.0.spaceW,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'] ?? 'N/A',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                4.0.spaceH,
                                Text(
                                  data['hospitalName'] ?? 'Hospital N/A',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Chip(
                            label: const Text(
                              "PENDING",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Colors.orange,
                          ),
                        ],
                      ),

                      14.0.spaceH,

                      /// 📄 DETAILS
                      _infoRow(
                        icon: Icons.badge,
                        title: "License No",
                        value: data['licenseNumber'] ?? 'N/A',
                      ),
                      8.0.spaceH,
                      _infoRow(
                        icon: Icons.date_range,
                        title: "Valid Till",
                        value:
                        DateFormat('yyyy-MM-dd').format(licenseTo),
                      ),

                      18.0.spaceH,

                      /// 🔘 ACTION BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.check , color: Colors.white,),
                              label: const Text("Approve" ,style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () =>
                                  _confirmAction(docId, 'approved'),
                            ),
                          ),
                          12.0.spaceW,
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.close , color: Colors.white,),
                              label: const Text("Reject" , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () =>
                                  _confirmAction(docId, 'rejected'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ℹ️ INFO ROW WIDGET
  Widget _infoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryColorBlue),
        8.0.spaceW,
        Text(
          "$title:",
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        6.0.spaceW,
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  /// 🔔 CONFIRM DIALOG
  void _confirmAction(String docId, String status) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(
          status == 'approved'
              ? "Approve Dermatologist"
              : "Reject Dermatologist",
        ),
        content: Text(
          status == 'approved'
              ? "Are you sure you want to approve this dermatologist?"
              : "Are you sure you want to reject this dermatologist?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              status == 'approved' ? Colors.green : Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              _updateStatus(docId, status);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  /// 🔄 UPDATE STATUS
  Future<void> _updateStatus(String docId, String status) async {
    try {
      setState(() => _isLoading = true);

      await FirebaseFirestore.instance
          .collection('dermatologists')
          .doc(docId)
          .update({
        "approvalStatus": status,
        "approvedAt": Timestamp.now(),
      });

      CommonSnackBar.getSnackBar(
        backgroundColor: status == 'approved'
            ? Colors.green
            : Colors.red,
        title: "Success",
        message: status == 'approved'
            ? "Dermatologist approved"
            : "Dermatologist rejected",
      );
    } catch (e) {
      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.red,
        title: "Error",
        message: e.toString(),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
