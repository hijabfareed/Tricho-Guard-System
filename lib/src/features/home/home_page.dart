
import 'dart:convert';

import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_bottomsheet.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/constants/apiData.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/features/widget/message_box.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final storage = GetStorage();

  String name = "";
  String doctorId = "";
  String chatDocumentId = "";


  final TextEditingController messageController = TextEditingController();


  @override
  void initState() {
    super.initState();
    getUser();
    checkCompletedBookingsForReview();
  }


  Future<void> checkCompletedBookingsForReview() async {

    final uid = storage.read('userid');

    final snap = await FirebaseFirestore.instance
        .collection('booking')
        .where('patientId', isEqualTo: uid)
        .where('status', isEqualTo: 'completed')
        .where('isReviewed', isEqualTo: false)
        .get();

    if (snap.docs.isNotEmpty) {

      final booking = snap.docs.first;
      final doctorId = booking['doctorId'];

      _openReviewSheet(booking.id, doctorId);
    }
  }

  void _openReviewSheet(String bookingId, String doctorId) {

    double rating = 0;
    bool isSubmitting = false;
    final reviewController = TextEditingController();

    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      isDismissible: true,
      StatefulBuilder(
        builder: (context, setStateSheet) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  Text(
                    doctorId == "tricho_guard_app" ? "Rate Our App" : "Rate Your Doctor",
                    style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff407CE2),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your feedback helps us improve our services",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),

                  const SizedBox(height: 30),

                  /// ⭐ STAR RATING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setStateSheet(() {
                            rating = index + 1.0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(
                            index < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: index < rating ? Colors.amber : Colors.grey.shade300,
                            size: 46,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 25),

                  /// 📝 REVIEW TEXT
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Write your feedback...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xffF8FAFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xff407CE2), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ✅ SUBMIT BUTTON
                  if (isSubmitting)
                    const Center(child: CircularProgressIndicator(color: Color(0xff407CE2)))
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (rating == 0) {
                            CommonSnackBar.getSnackBar(
                              title: "Rating Required",
                              message: "Please select a star rating",
                              backgroundColor: Colors.redAccent,
                            );
                            return;
                          }

                          setStateSheet(() => isSubmitting = true);

                          await _submitReview(
                            bookingId,
                            doctorId,
                            rating,
                            reviewController.text,
                          );

                          if (mounted) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff407CE2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Future<void> _submitReview(
      String bookingId,
      String doctorId,
      double rating,
      String comment,
      ) async {

    final uid = storage.read('userid');

    try {
      /// 1️⃣ Save Review
      await FirebaseFirestore.instance
          .collection('reviews')
          .add({
        "bookingId": bookingId,
        "doctorId": doctorId,
        "patientId": uid,
        "patientName": name,
        "rating": rating,
        "comment": comment,
        "createdAt": Timestamp.now(),
      });

      /// 2️⃣ Mark Booking Reviewed
      if(bookingId != "app_feedback" && bookingId != "manual_feedback") {
        await FirebaseFirestore.instance
            .collection('booking')
            .doc(bookingId)
            .update({
          "isReviewed": true,
        });
      }

      /// 🔔 Notify Doctor
      if(doctorId != "tricho_guard_app") {
        await FirebaseFirestore.instance.collection('notifications').add({
          "doctorId": doctorId,
          "title": "New Feedback received",
          "message": "$name gave you a $rating star rating.",
          "isRead": false,
          "createdAt": Timestamp.now(),
        });

        /// 3️⃣ Recalculate Doctor Average Rating
        final reviews = await FirebaseFirestore.instance
            .collection('reviews')
            .where('doctorId', isEqualTo: doctorId)
            .get();

        double total = 0;
        for (var doc in reviews.docs) {
          total += doc['rating'];
        }

        double average = reviews.docs.isEmpty ? rating : total / reviews.docs.length;

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(doctorId)
            .update({
          "rating": double.parse(average.toStringAsFixed(1)),
        });
      }

      CommonSnackBar.getSnackBar(
        title: "Thank You",
        message: "Review submitted successfully",
        backgroundColor: Colors.green,
      );
    } catch (e) {
      debugPrint("Error submitting review: $e");
      CommonSnackBar.getSnackBar(
        title: "Error",
        message: "Something went wrong. Please try again.",
        backgroundColor: Colors.red,
      );
    }
  }


  Future<void> sendTextMessage() async {
    if (messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("Chat_Room")
        .add({
      "docId": chatDocumentId,
      "senderId": storage.read('userid'),
      "type": "text",
      "message": messageController.text.trim(),
      "createdAt": Timestamp.now(),
    });

    messageController.clear();
  }

  Future<void> sendDocument() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      withData: true,
    );

    if (result == null) return;

    final fileBytes = result.files.first.bytes;
    final fileName = result.files.first.name;

    if (fileBytes == null) return;

    final base64File = base64Encode(fileBytes);

    await FirebaseFirestore.instance
        .collection("Chat_Room")
        .add({
      "docId": chatDocumentId,
      "senderId": storage.read('userid'),
      "type": "document",
      "fileName": fileName,
      "base64": base64File,
      "createdAt": Timestamp.now(),
    });
  }




  // ================= CREATE CHAT DOC =================

  Future<void> createChatDoc() async {
    final existing = await FirebaseFirestore.instance
        .collection('chat')
        .where('user1', isEqualTo: storage.read('userid'))
        .where('user2', isEqualTo: doctorId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      chatDocumentId = existing.docs.first.id;
      return;
    }

    final ref = FirebaseFirestore.instance.collection('chat').doc();
    chatDocumentId = ref.id;

    await ref.set({
      "docId": ref.id,
      "user1": storage.read('userid'),
      "user2": doctorId,
      "createdAt": Timestamp.now(),
    });
  }

  // ================= CHAT ROOM =================

  void _openChatRoom() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Chat",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff407CE2),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ================= MESSAGE LIST =================

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Chat_Room")
                    .where('docId',
                    isEqualTo: chatDocumentId)
                    .orderBy('createdAt',
                    descending: true)
                    .snapshots(),
                builder: (_, snap) {

                  if (!snap.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  if (snap.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No messages yet"));
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snap.data!.docs.length,
                    itemBuilder: (_, i) {

                      final d = snap.data!.docs[i];
                      final isMe =
                          d['senderId'] ==
                              storage.read('userid');

                      final type = d['type'] ?? "text";

                      /// ================= TEXT MESSAGE =================
                      if (type == "text") {
                        return MessageWidget(
                          isSender: isMe,
                          message: d['message'] ?? "",
                        );
                      }

                      /// ================= DOCUMENT MESSAGE =================
                      if (type == "document") {

                        return Align(
                          alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? const Color(0xff407CE2)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Icon(
                                  Icons.insert_drive_file,
                                  color: isMe
                                      ? Colors.white
                                      : Colors.black,
                                ),

                                const SizedBox(width: 8),

                                Flexible(
                                  child: Text(
                                    d['fileName'] ?? "Document",
                                    style: TextStyle(
                                      color: isMe
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      /// ================= DEFAULT FALLBACK =================
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// ================= INPUT FIELD =================

            Row(
              children: [

                /// 📎 Attach File
                IconButton(
                  icon: const Icon(
                    Icons.attach_file,
                    color: Color(0xff407CE2),
                  ),
                  onPressed: () async {
                    await sendDocument();
                  },
                ),

                /// Text Field
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// Send Text
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Color(0xff407CE2),
                  ),
                  onPressed: () async {
                    await sendTextMessage();
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  // ================= BOOKING SHEET =================

  void _openBookingSheet() {
    getIt<NavigationService>().navigateTo(
      NavigationPath.bookingPage,
      data: {
        "doctorId": doctorId,
      },
    );
  }

  // ================= NOTIFICATIONS =================

  void _openNotifications() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Notifications",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff407CE2),
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('notifications')
                    .where('patientId',
                    isEqualTo:
                    storage.read('userid'))
                    .orderBy('createdAt',
                    descending: true)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) {
                    return const Center(
                        child: Text("No notifications"));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final doc = docs[i];
                      final data =
                      doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: const Icon(
                            Icons.notifications, color: Color(0xff407CE2)),
                        title:
                        Text(data['title'] ?? "", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                        subtitle:
                        Text(data['message'] ?? "", style: const TextStyle(color: Colors.black54)),
                        trailing: data['isRead'] == true
                            ? null
                            : const Icon(Icons.circle,
                            size: 10,
                            color: Colors.red),
                        onTap: () async {
                          await doc.reference
                              .update({"isRead": true});
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= DOCTOR LIST =================

  void _openDoctorSelection() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      isDismissible: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Doctor",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff407CE2),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('role', isEqualTo: 'doctor')
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final doctors = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (_, i) {
                      final doc = doctors[i];
                      final data =
                      doc.data() as Map<String, dynamic>;

                      final rating =
                      data.containsKey('rating')
                          ? data['rating']
                          : 0;

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xff407CE2),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title:
                        Text(data['name'] ?? "Doctor", style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber,
                                size: 16),
                            const SizedBox(width: 4),
                            Text(rating.toString(), style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                        onTap: () {
                          doctorId = doc.id;
                          Navigator.pop(context);
                          _openDoctorActions();
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ACTION SHEET =================

  void _openDoctorActions() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CommonButton(
              title: "💬 Start Chat",
              onTap: () async {
                await createChatDoc();
                Navigator.pop(context);
                _openChatRoom();
              },
            ),

            const SizedBox(height: 12),

            CommonButton(
              title: "📅 Book Appointment",
              onTap: () {
                Navigator.pop(context);
                _openBookingSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: false,
      title: const Text(""),
      child: Container(
        color: const Color(0xFFF8FAFF), // Light background to make white cards pop
        child: Column(
          children: [

            /// ================= PREMIUM HEADER =================

            Container(
              height: 260,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff407CE2), Color(0xff6AA9FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [

                  /// Notification Row
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      const Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      IconButton(
                        onPressed: _openNotifications,
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        Assets.imagesHomePage,
                        height: 140,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            /// ================= PREMIUM GRID =================

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: 0.9, // Adjusting ratio for better look
                      children: [

                        _premiumCard(
                            "Profile Update",
                            Icons.person_outline,
                            () async{
                              await getIt<NavigationService>()
                                  .navigateTo(
                                  NavigationPath.profileUpdatePage);

                              await getUser();
                            }),

                        _premiumCard(
                            "Export Data",
                            Icons.download_outlined,
                            () {
                              getIt<NavigationService>()
                                  .navigateTo(
                                  NavigationPath.exportDataPage);
                            }),

                        _premiumCard(
                            "Consultation",
                            Icons.medical_services_outlined,
                            () {
                              _openDoctorSelection();
                            }),


                        _premiumCard(
                            "Language",
                            Icons.language,
                            () {
                              getIt<NavigationService>()
                                  .navigateTo(
                                  NavigationPath.languagePage);
                            }),


                        _premiumCard(
                          "AI Scalp Scan",
                          Icons.analytics_outlined,
                          () {
                            getIt<NavigationService>()
                                .navigateTo(NavigationPath.connectDevicePage);
                          },
                        ),

                        _premiumCard(
                          "AI Image Scalp",
                          Icons.analytics_outlined,
                          () {
                            getIt<NavigationService>()
                                .navigateTo(
                                NavigationPath.connectDevice);
                          },
                        ),

                        _premiumCard(
                          "Alerts",
                          Icons.notifications_active_outlined,
                          () {
                            getIt<NavigationService>()
                                .navigateTo(
                                NavigationPath.patientAlertPage);
                          },
                        ),


                        _premiumCard(
                            "Feedback",
                            Icons.feedback_outlined,
                            _openFeedback),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// ================= LOGOUT BUTTON =================

                    InkWell(
                      onTap: _logout,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff407CE2).withOpacity(0.15),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout,
                              color: Color(0xff407CE2),
                              size: 30,
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Logout",
                              style: TextStyle(
                                color: Color(0xff407CE2),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _premiumCard(
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22), // Slightly more rounded
          boxShadow: [
            BoxShadow(
              color: const Color(0xff407CE2).withOpacity(0.12), // Deeper shadow for visibility
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
          // Subtle border for extra definition
          border: Border.all(color: const Color(0xff407CE2).withOpacity(0.05), width: 1),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff407CE2).withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xff407CE2),
                size: 32,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xff407CE2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUser() async {
    final u = await ApiData.user
        .doc(storage.read('userid'))
        .get();
    setState(() =>
    name = u['name'] ?? 'User');
  }

  void _openFeedback() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      isDismissible: true,
      Container(
        height: 350,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Provide Feedback",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xff407CE2),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            CommonButton(
              title: "⭐ Rate Your Doctor",
              onTap: () {
                Navigator.pop(context);
                _openDoctorSelectionForFeedback();
              },
            ),
            const SizedBox(height: 15),
            CommonButton(
              title: "📱 Rate Tricho Guard App",
              onTap: () {
                Navigator.pop(context);
                _openReviewSheet("app_feedback", "tricho_guard_app");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openDoctorSelectionForFeedback() {
    CommonBottomSheet.showBottomSheet(
      context,
      isScrollControlled: true,
      isDismissible: true,
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Select Doctor for Feedback",
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xff407CE2),
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .where('role', isEqualTo: 'doctor')
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final doctors = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: doctors.length,
                    itemBuilder: (_, i) {
                      final doc = doctors[i];
                      final data =
                      doc.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xff407CE2),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title:
                        Text(data['name'] ?? "Doctor", style: const TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.pop(context);
                          _openReviewSheet("manual_feedback", doc.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance
        .signOut();
    storage.erase();
    getIt<NavigationService>()
        .goBackUntilAndPush(
        NavigationPath
            .letStartPage);
  }
}
