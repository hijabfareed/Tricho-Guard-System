import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_dialog.dart';
import 'package:al_hair_app/src/common/widget/common_dropdown.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/common/widget/common_text_field.dart';
import 'package:al_hair_app/src/constants/apiData.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  /// 🔐 CHANGE THIS CODE FOR PRODUCTION
  static const String ADMIN_SECRET_CODE = "ADMIN@123";

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController role = TextEditingController(text: "patient");
  TextEditingController adminCode = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  List roleList = [
    {"id": "admin", "name": "Admin"},
    {"id": "doctor", "name": "Doctor"},
    {"id": "patient", "name": "Patient"},
  ];

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Sign Up",
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    50.0.spaceH,

                    /// NAME
                    _label("Name"),
                    20.0.spaceH,
                    CommonTextField(
                      controller: name,
                      borderColor: AppColors.lightGray.withValues(alpha: 0.4),
                      prefixIcon: SvgPicture.asset(Assets.imagesUser).paddingAll(10),
                      radius: 10,
                      hintText: "Enter your name",
                    ),

                    20.0.spaceH,

                    /// EMAIL
                    _label("Email"),
                    20.0.spaceH,
                    CommonTextField(
                      controller: email,
                      borderColor: AppColors.lightGray.withValues(alpha: 0.4),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: SvgPicture.asset(Assets.imagesEmail).paddingAll(10),
                      radius: 10,
                      hintText: "Enter your email",
                    ),

                    20.0.spaceH,

                    /// PASSWORD
                    _label("Password"),
                    20.0.spaceH,
                    CommonTextField(
                      controller: password,
                      borderColor: AppColors.lightGray.withValues(alpha: 0.4),
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: SvgPicture.asset(Assets.imagesLock).paddingAll(10),
                      radius: 10,
                      hintText: "Enter password",
                    ),

                    20.0.spaceH,

                    /// ROLE
                    _label("Role"),
                    10.0.spaceH,
                    CommonDropDownField(
                      controller: role,
                      placeholder: '',
                      values: roleList,
                      checkedValue: role,
                      isBorderShow: true,
                      borderColor: AppColors.lightGrey.withValues(alpha: 0.4),
                      height: 50,
                      borderRadius: 5.0,
                      isUnderlineBorder: false,
                      fillColor: AppColors.borderColor,
                      doCallback: () {
                        setState(() {});
                      },
                    ),

                    /// 🔐 ADMIN SECRET CODE (ONLY IF ADMIN)
                    if (role.text == "admin") ...[
                      20.0.spaceH,
                      _label("Admin Secret Code"),
                      10.0.spaceH,
                      CommonTextField(
                        controller: adminCode,
                        borderColor: AppColors.lightGray.withValues(alpha: 0.4),
                        hintText: "Enter admin code",
                      ),
                    ],
                  ],
                ).paddingOnly(left: 25, right: 25),
              ),
            ),

            20.0.spaceH,

            /// SIGNUP BUTTON
            CommonButton(
              title: "Sign Up",
              onTap: signupUser,
            ).paddingOnly(left: 25, right: 25),

            50.0.spaceH,
          ],
        ),
      ),
    );
  }

  /// 🧠 SIGNUP LOGIC
  Future<void> signupUser() async {
    if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.blueAccent,
        title: "Info",
        message: "Please fill all fields",
      );
      return;
    }

    /// 🔐 ADMIN CODE CHECK
    if (role.text == "admin" && adminCode.text.trim() != ADMIN_SECRET_CODE) {
      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.red,
        title: "Access Denied",
        message: "Invalid admin secret code",
      );
      return;
    }

    try {
      _showDialogConnecting();

      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await ApiData.user.doc(result.user!.uid).set({
        "id": result.user!.uid,
        "name": name.text.trim(),
        "email": email.text.trim(),
        "role": role.text,
        "isBlocked": false,
        "createdAt": DateTime.now(),
      });

      await result.user!.sendEmailVerification();

      if (!mounted) return;
      // Close the connecting dialog
      Navigator.of(context, rootNavigator: true).pop();

      // Show professional verification dialog
      _showEmailVerificationDialog();

      name.clear();
      email.clear();
      password.clear();
      adminCode.clear();

    } catch (e) {
      if (mounted) {
        // Try to pop the dialog if it exists, otherwise just show snackbar
        try { Navigator.of(context, rootNavigator: true).pop(); } catch (_) {}

        CommonSnackBar.getSnackBar(
          backgroundColor: Colors.red,
          title: "Signup Failed",
          message: e.toString(),
        );
      }
    }
  }

  /// 📧 EMAIL VERIFICATION DIALOG
  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_read_rounded, size: 80, color: Color(0xff407CE2)),
                const SizedBox(height: 24),
                const Text(
                  "Verify Your Email",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text(
                  "A verification link has been sent to your email address. Please check your inbox.\n\nNote: If you don't see it, please check your SPAM folder.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                ),
                const SizedBox(height: 32),
                CommonButton(
                  title: "Proceed to Login",
                  onTap: () {
                    Navigator.pop(context); // Close Dialog
                    getIt<NavigationService>().goBack(); // Go back to Login
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 🔄 LOADER
  void _showDialogConnecting() {
    CommonDialog.showCustomDialog(
      context,
      Container(
        height: 150,
        width: 150,
        color: AppColors.primaryColorWhite,
        child: LoadingAnimationWidget.newtonCradle(
          color: const Color(0xff407CE2),
          size: 50,
        ).center(),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ).leftAlign();
  }
}
