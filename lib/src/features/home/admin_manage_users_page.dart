import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Manage Users",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      child: Container(
        color: const Color(0xFFF8FAFF),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('role', whereIn: ['doctor', 'patient'])
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
              physics: const BouncingScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final doc = users[index];
                final data = doc.data() as Map<String, dynamic>;

                final bool isBlocked = data['isBlocked'] ?? false;
                final String role = data['role'] ?? 'patient';

                return Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: const Color(0xff407CE2).withOpacity(0.1)),
                  ),
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff407CE2).withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 👤 AVATAR
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: _roleColor(role).withOpacity(0.1),
                            child: Text(
                              (data['name'] ?? 'U')
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _roleColor(role),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// 📄 USER INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                /// NAME
                                Text(
                                  data['name'] ?? 'No Name',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),

                                const SizedBox(height: 2),

                                /// EMAIL
                                Text(
                                  data['email'] ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                /// BADGES
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    _buildBadge(role, _roleColor(role)),
                                    _buildBadge(
                                      isBlocked ? "BLOCKED" : "ACTIVE",
                                      isBlocked ? Colors.red : Colors.green,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// 🔒 SWITCH
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: Switch(
                                  value: !isBlocked,
                                  activeColor: Colors.green,
                                  inactiveThumbColor: Colors.red,
                                  onChanged: (value) {
                                    _toggleBlockUser(
                                      userId: doc.id,
                                      block: !value,
                                    );
                                  },
                                ),
                              ),
                              Text(
                                isBlocked ? "Unblock" : "Block",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: isBlocked ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🔒 BLOCK / UNBLOCK USER
  Future<void> _toggleBlockUser({
    required String userId,
    required bool block,
  }) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update({
      "isBlocked": block,
      "updatedAt": Timestamp.now(),
    });

    CommonSnackBar.getSnackBar(
      backgroundColor: block ? Colors.red : Colors.green,
      title: "Success",
      message: block
          ? "User has been blocked"
          : "User has been unblocked",
    );
  }

  /// 🎨 ROLE COLORS
  Color _roleColor(String role) {
    switch (role) {
      case 'doctor':
        return const Color(0xff407CE2);
      case 'patient':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
