import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int totalUsers = 0;
  int totalDoctors = 0;
  int totalPatients = 0;

  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  /// 🔢 LOAD COUNTS FROM FIRESTORE
  Future<void> _loadCounts() async {
    final usersSnapshot =
    await FirebaseFirestore.instance.collection('Users').get();

    int users = 0;
    int doctors = 0;
    int patients = 0;

    for (var doc in usersSnapshot.docs) {
      users++;
      final role = doc.data()['role'];

      if (role == 'doctor') doctors++;
      if (role == 'patient') patients++;
    }

    setState(() {
      totalUsers = users;
      totalDoctors = doctors;
      totalPatients = patients;
    });
  }

  /// 🔴 LOGOUT
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    storage.erase();

    getIt<NavigationService>().goBackUntilAndPush(
      NavigationPath.letStartPage,
    );

    CommonSnackBar.getSnackBar(
      backgroundColor: Colors.green,
      title: "Logout",
      message: "Admin logged out successfully",
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xff407CE2);

    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Admin Dashboard",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      child: Container(
        color: const Color(0xFFF8FAFF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 👋 Welcome
              const Text(
                "Welcome, Admin 👋",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Here’s what’s happening in your system today",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              /// 📊 Stats
              Row(
                children: [
                  Expanded(
                    child: _StatsCard(
                      title: "Total Users",
                      value: totalUsers.toString(),
                      icon: Icons.people,
                      color: primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatsCard(
                      title: "Doctors",
                      value: totalDoctors.toString(),
                      icon: Icons.medical_services,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatsCard(
                      title: "Patients",
                      value: totalPatients.toString(),
                      icon: Icons.person,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: _StatsCard(
                      title: "Reports",
                      value: "—",
                      icon: Icons.analytics,
                      color: primaryBlue, // Changed from Purple to Blue
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// 🧩 Modules
              const Text(
                "Admin Modules",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _ModuleCard(
                    icon: Icons.verified_user,
                    title: "Dermatologist Approvals",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminApprovalPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.manage_accounts,
                    title: "Manage Users",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminManageUsersPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.health_and_safety,
                    title: "System Health",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.systemHealthPage,
                      );
                    },
                  ),
                  const _ModuleCard(
                    icon: Icons.backup,
                    title: "Backup & Restore",
                  ),
                  _ModuleCard(
                    icon: Icons.monitor,
                    title: "System Status",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminSystemStatusPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.psychology,
                    title: "AI Accuracy",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminAiAccuracyPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.feedback,
                    title: "User Feedbacks", // Renamed for clarity
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminDoctorRatingsPage,
                      );
                    },

                  ),
                  _ModuleCard(
                    icon: Icons.security,
                    title: "Roles & Access",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminRoleAccessPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.app_registration, // Changed icon for Feedback entry
                    title: "Feedback List", // User said convert FAQ to Feedback
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminDoctorRatingsPage,
                      );
                    },
                  ),
                  _ModuleCard(
                    icon: Icons.notifications_active,
                    title: "Notifications",
                    onTap: () {
                      getIt<NavigationService>().navigateTo(
                        NavigationPath.adminNotificationsPage,
                      );
                    },
                  )
                ],
              ),

              const SizedBox(height: 30),

              /// 🔴 LOGOUT BUTTON
              InkWell(
                onTap: _logout,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// 📊 STATS CARD
class _StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatsCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 🧩 MODULE CARD
class _ModuleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _ModuleCard({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xff407CE2);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: primaryBlue.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: primaryBlue.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: primaryBlue),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
