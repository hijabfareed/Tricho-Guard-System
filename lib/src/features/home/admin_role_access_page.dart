import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminRoleAccessPage extends StatefulWidget {
  const AdminRoleAccessPage({super.key});

  @override
  State<AdminRoleAccessPage> createState() => _AdminRoleAccessPageState();
}

class _AdminRoleAccessPageState extends State<AdminRoleAccessPage> {
  final List<String> roles = ['admin', 'doctor', 'patient'];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Role & Access Management",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('role', isNotEqualTo: 'admin') // ❌ admin exclude
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;
              final String currentRole = data['role'] ?? 'patient';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 👤 USER AVATAR
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                        _roleColor(currentRole).withOpacity(0.15),
                        child: Text(
                          (data['name'] ?? 'U')
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _roleColor(currentRole),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// 📄 USER INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// NAME
                            Text(
                              data['name'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// EMAIL
                            Text(
                              data['email'] ?? '',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// ROLE CHIP + DROPDOWN
                            Row(
                              children: [
                                Chip(
                                  backgroundColor:
                                  _roleColor(currentRole),
                                  label: Text(
                                    currentRole.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: currentRole,
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    items: roles.map((role) {
                                      return DropdownMenuItem(
                                        value: role,
                                        child: Text(
                                          role.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) async {
                                      if (value == null ||
                                          value == currentRole) return;

                                      await _updateUserRole(
                                        userId: doc.id,
                                        newRole: value,
                                      );

                                      CommonSnackBar.getSnackBar(
                                        backgroundColor: Colors.green,
                                        title: "Updated",
                                        message:
                                        "Role changed to ${value.toUpperCase()}",
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  /// 🔄 UPDATE ROLE IN FIRESTORE
  Future<void> _updateUserRole({
    required String userId,
    required String newRole,
  }) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({
      "role": newRole,
      "updatedAt": Timestamp.now(),
    });
  }

  /// 🎨 ROLE COLORS
  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'doctor':
        return Colors.blue;
      case 'patient':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
