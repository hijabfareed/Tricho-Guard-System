import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {

  final storage = GetStorage();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// ================= LOAD USER DATA =================

  Future<void> loadUserData() async {

    final uid = storage.read('userid');

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (doc.exists) {
      nameController.text = doc['name'] ?? "";
      emailController.text = doc['email'] ?? "";
    }
  }

  /// ================= UPDATE PROFILE =================

  Future<void> updateProfile() async {

    final uid = storage.read('userid');
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty) {

      CommonSnackBar.getSnackBar(
        title: "Missing Fields",
        message: "Name & Email required",
        backgroundColor: Colors.red,
      );
      return;
    }

    try {

      setState(() => isLoading = true);

      /// 1️⃣ Update Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
      });

      /// 2️⃣ Update Email (New Firebase way)
      if (user.email != emailController.text.trim()) {

        await user.verifyBeforeUpdateEmail(
            emailController.text.trim());

        CommonSnackBar.getSnackBar(
          title: "Verification Sent",
          message: "Check your email to confirm change",
          backgroundColor: Colors.blue,
        );
      }

      /// 3️⃣ Update Password (Optional)
      if (passwordController.text.isNotEmpty) {

        await user.updatePassword(
            passwordController.text.trim());
      }

      setState(() => isLoading = false);

      CommonSnackBar.getSnackBar(
        title: "Success",
        message: "Profile updated successfully",
        backgroundColor: Colors.green,
      );

    } catch (e) {

      setState(() => isLoading = false);

      CommonSnackBar.getSnackBar(
        title: "Error",
        message: e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return CommonScaffold(
      withAppBar: true,
      title: const Text("Update Profile"),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// 🔷 HEADER CARD
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
                  Icon(Icons.person,
                      color: Colors.white, size: 30),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Update your account information",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// NAME FIELD
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// EMAIL FIELD
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email Address",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// PASSWORD FIELD
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password (Optional)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            /// UPDATE BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff407CE2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: updateProfile,
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors.white,
                )
                    : const Text(
                  "Save Changes",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
