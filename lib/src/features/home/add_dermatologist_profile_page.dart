import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/common/widget/common_text_field.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AddDermatologistProfilePage extends StatefulWidget {
  const AddDermatologistProfilePage({super.key});

  @override
  State<AddDermatologistProfilePage> createState() =>
      _AddDermatologistProfilePageState();
}

class _AddDermatologistProfilePageState
    extends State<AddDermatologistProfilePage> {
  final storage = GetStorage();

  final nameController = TextEditingController();
  final hospitalController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final licenseFromController = TextEditingController();
  final licenseToController = TextEditingController();

  DateTime? licenseFrom;
  DateTime? licenseTo;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text("Dermatologist Profile"),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Complete Your Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            10.0.spaceH,
            const Text(
              "Admin approval is required after submission.",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            30.0.spaceH,

            /// 👤 Name
            CommonTextField(
              controller: nameController,
              hintText: "Doctor Name",
              radius: 10,
            ),
            20.0.spaceH,

            /// 🏥 Hospital
            CommonTextField(
              controller: hospitalController,
              hintText: "Hospital Name",
              radius: 10,
            ),
            20.0.spaceH,

            /// 🪪 License Number
            CommonTextField(
              controller: licenseNumberController,
              hintText: "Medical License Number",
              radius: 10,
            ),
            20.0.spaceH,

            /// 📅 License From
            CommonTextField(
              controller: licenseFromController,
              hintText: "License Valid From",
              readOnly: true,
              radius: 10,
              onTap: () async {
                licenseFrom = await _pickDate();
                if (licenseFrom != null) {
                  licenseFromController.text =
                      DateFormat('yyyy-MM-dd').format(licenseFrom!);
                }
              },
            ),
            20.0.spaceH,

            /// 📅 License To
            CommonTextField(
              controller: licenseToController,
              hintText: "License Valid To",
              readOnly: true,
              radius: 10,
              onTap: () async {
                licenseTo = await _pickDate();
                if (licenseTo != null) {
                  licenseToController.text =
                      DateFormat('yyyy-MM-dd').format(licenseTo!);
                }
              },
            ),
            40.0.spaceH,

            /// ✅ SUBMIT
            CommonButton(
              title: "Submit Profile",
              onTap: _submitProfile,
            ),
          ],
        ),
      ),
    );
  }

  // 📆 Date Picker
  Future<DateTime?> _pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
  }

  // 🚀 SUBMIT PROFILE
  Future<void> _submitProfile() async {
    if (nameController.text.isEmpty ||
        hospitalController.text.isEmpty ||
        licenseNumberController.text.isEmpty ||
        licenseFrom == null ||
        licenseTo == null) {
      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.red,
        title: "Error",
        message: "Please fill all fields",
      );
      return;
    }

    final uid = storage.read('userid');

    await FirebaseFirestore.instance
        .collection('dermatologists')
        .doc(uid)
        .set({
      "name": nameController.text,
      "hospitalName": hospitalController.text,
      "licenseNumber": licenseNumberController.text,
      "licenseFrom": Timestamp.fromDate(licenseFrom!),
      "licenseTo": Timestamp.fromDate(licenseTo!),
      "approvalStatus": "pending",
      "profileCompleted": true,
      "createdAt": Timestamp.now(),
    });

    CommonSnackBar.getSnackBar(
      backgroundColor: Colors.green,
      title: "Submitted",
      message: "Profile submitted. Waiting for admin approval.",
    );

    getIt<NavigationService>()
        .goBackUntilAndPush(NavigationPath.doctorHomePage);
  }
}
