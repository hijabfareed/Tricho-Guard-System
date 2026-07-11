import 'package:al_hair_app/src/common/widget/common_bottomsheet.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {

  final storage = GetStorage();

  String name = "";
  int totalBookings = 0;
  int totalChats = 0;
  int totalPatients = 0;

  List reviewList = [];

  bool isProfileCompleted = true; // Default to true to allow access if field missing
  String approvalStatus = "active"; // Default to active

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    await getUser();
    await loadDashboardStats();
    await loadReviews();
  }

  Future<void> loadReviews() async {
    final uid = storage.read('userid');
    if (uid == null) return;
    
    final snap = await FirebaseFirestore.instance
        .collection('reviews')
        .where('doctorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();

    if (mounted) {
      setState(() {
        reviewList = snap.docs;
      });
    }
  }

  Future<void> getUser() async {
    final uid = storage.read('userid');
    if (uid == null) return;

    // 🟢 FIXED: Using 'Users' collection instead of 'dermatologists'
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (!doc.exists) return;

    if (mounted) {
      setState(() {
        name = doc.get('name') ?? "Doctor";
        // Check for profile status, but don't block if fields don't exist yet
        final data = doc.data() as Map<String, dynamic>;
        isProfileCompleted = data.containsKey('profileCompleted') ? data['profileCompleted'] : true;
        approvalStatus = data.containsKey('approvalStatus') ? data['approvalStatus'] : "active";
      });
    }

    /// 🔒 Access Check
    Future.delayed(Duration.zero, () {
      _checkAccess();
    });
  }

  void _checkAccess() {
    if (!isProfileCompleted) {
      _showProfileIncompleteDialog();
      return;
    }

    if (approvalStatus == "pending") {
      _showApprovalPendingDialog();
      return;
    }

    if (approvalStatus == "rejected") {
      _showRejectedDialog();
      return;
    }
  }

  void _showRejectedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Application Rejected"),
        content: const Text(
            "Your profile has been rejected by admin. Please contact support."),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              storage.erase();
              getIt<NavigationService>()
                  .goBackUntilAndPush(
                  NavigationPath.letStartPage);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  void _showProfileIncompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Profile Incomplete"),
        content: const Text(
            "Please complete your profile before using the app."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              getIt<NavigationService>()
                  .navigateTo(
                  NavigationPath.profileUpdatePage);
            },
            child: const Text("Complete Now"),
          ),
        ],
      ),
    );
  }

  void _showApprovalPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Waiting for Approval"),
        content: const Text(
            "Your profile has been submitted and is waiting for admin approval."),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              storage.erase();
              getIt<NavigationService>()
                  .goBackUntilAndPush(
                  NavigationPath.letStartPage);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  Future<void> loadDashboardStats() async {
    final uid = storage.read('userid');
    if (uid == null) return;

    final bookingSnap = await FirebaseFirestore.instance
        .collection('booking')
        .where('doctorId', isEqualTo: uid)
        .get();

    final chatSnap = await FirebaseFirestore.instance
        .collection('chat')
        .where('user2', isEqualTo: uid)
        .get();

    if (mounted) {
      setState(() {
        totalBookings = bookingSnap.docs.length;
        totalChats = chatSnap.docs.length;
        totalPatients = chatSnap.docs.length;
      });
    }
  }

  void changeLanguage(String code) {
    Get.updateLocale(Locale(code));
    storage.write("appLanguage", code);
  }

  Stream<QuerySnapshot> doctorNotificationStream() {
    final uid = storage.read('userid');
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('doctorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: false,
      child: Container(
        color: const Color(0xFFF8FAFF), // Matches patient theme
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /// ================= HEADER =================
              Container(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff407CE2), Color(0xff6AA9FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Welcome 👋", style: TextStyle(color: Colors.white, fontSize: 16)),
                        Row(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: doctorNotificationStream(),
                              builder: (context, snapshot) {
                                int count = 0;
                                if (snapshot.hasData) {
                                  count = snapshot.data!.docs.where((e) => e['isRead'] == false).length;
                                }
                                return Stack(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.notifications, color: Colors.white),
                                      onPressed: _openNotifications,
                                    ),
                                    if (count > 0)
                                      Positioned(
                                        right: 6,
                                        top: 6,
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          child: Text(count.toString(), style: const TextStyle(color: Colors.white, fontSize: 10)),
                                        ),
                                      )
                                  ],
                                );
                              },
                            ),
                            PopupMenuButton(
                              icon: const Icon(Icons.language, color: Colors.white),
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: "en", child: Text("English")),
                                PopupMenuItem(value: "ar", child: Text("Arabic")),
                              ],
                              onSelected: changeLanguage,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statCard(totalBookings.toString(), "Bookings"),
                        _statCard(totalChats.toString(), "Chats"),
                        _statCard(totalPatients.toString(), "Patients"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// ================= ACTION GRID =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.1,
                  children: [
                    _actionCard(Icons.calendar_today, "View Bookings", () {
                      getIt<NavigationService>().navigateTo(NavigationPath.doctorBookingPage);
                    }),
                    _actionCard(Icons.schedule, "My Availability", () {
                      getIt<NavigationService>().navigateTo(NavigationPath.doctorAvailabilityPage);
                    }),
                    _actionCard(Icons.chat_bubble_outline, "Chat Patients", () {
                      getIt<NavigationService>().navigateTo(NavigationPath.doctorPatientListPage);
                    }),
                    _actionCard(Icons.notification_important_outlined, "Patient Alerts", () {
                      getIt<NavigationService>().navigateTo(NavigationPath.doctorAlertPage);
                    }, color: Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= LOGOUT BUTTON =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: _logout,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff407CE2).withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Color(0xff407CE2), size: 30),
                        SizedBox(width: 16),
                        Text("Logout", style: TextStyle(color: Color(0xff407CE2), fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// ================= FEEDBACK SECTION =================
              _feedbackSection(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _openNotifications() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: doctorNotificationStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            if (snapshot.data!.docs.isEmpty) return const Center(child: Text("No Notifications"));
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final time = (data['createdAt'] as Timestamp).toDate();
                return ListTile(
                  title: Text(data['title'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(data['message'] ?? ""),
                  trailing: Text(DateFormat("dd MMM").format(time), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  onTap: () => doc.reference.update({'isRead': true}),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: const Color(0xff407CE2).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xff407CE2))),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, VoidCallback onTap, {Color color = const Color(0xff407CE2)}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _feedbackSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Recent Feedbacks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff407CE2))),
          const SizedBox(height: 15),
          if (reviewList.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: const Center(child: Text("No reviews yet", style: TextStyle(color: Colors.grey))),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviewList.length,
              itemBuilder: (_, index) {
                final data = reviewList[index].data() as Map<String, dynamic>;
                final rating = (data['rating'] ?? 0).toDouble();
                final comment = data['comment'] ?? "";
                final time = (data['createdAt'] as Timestamp).toDate();

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < rating ? Colors.amber : Colors.grey.shade300))),
                          Text(DateFormat("dd MMM yyyy").format(time), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(comment, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.4)),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    storage.erase();
    getIt<NavigationService>().goBackUntilAndPush(NavigationPath.letStartPage);
  }
}
