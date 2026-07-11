import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_dialog.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/common/widget/common_text_field.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Login",
        style: TextStyle(
          fontSize: 15,
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

                    /// EMAIL
                    _label("Email"),
                    20.0.spaceH,
                    CommonTextField(
                      controller: email,
                      borderColor:
                      AppColors.lightGray.withValues(alpha: 0.4),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon:
                      SvgPicture.asset(Assets.imagesEmail).paddingAll(10),
                      radius: 10,
                      hintText: "Enter Your Email",
                    ),

                    20.0.spaceH,

                    /// PASSWORD
                    _label("Password"),
                    20.0.spaceH,
                    CommonTextField(
                      controller: password,
                      borderColor:
                      AppColors.lightGray.withValues(alpha: 0.4),
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon:
                      SvgPicture.asset(Assets.imagesLock).paddingAll(10),
                      radius: 10,
                      hintText: "Enter Your Password",
                    ),

                    10.0.spaceH,

                    /// FORGOT PASSWORD
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          getIt<NavigationService>().navigateTo(
                            NavigationPath.forgotPassword,
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    )
                  ],
                ).paddingOnly(left: 25, right: 25),
              ),
            ),

            /// LOGIN BUTTON
            CommonButton(
              title: "Login",
              onTap: () {
                if (email.text.isEmpty || password.text.isEmpty) {
                  CommonSnackBar.getSnackBar(
                    backgroundColor: Colors.blueAccent,
                    title: "Info",
                    message: "Please fill all fields",
                  );
                } else {
                  signIn();
                }
              },
            ).paddingOnly(left: 25, right: 25),

            50.0.spaceH,
          ],
        ),
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

  /// 🔐 ROBUST LOGIN
  Future<void> signIn() async {
    try {
      _showDialogConnecting();

      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = credential.user!;

      // Attempt to find user in 'Users' or 'users'
      var userDoc = await FirebaseFirestore.instance.collection('Users').doc(user.uid).get();
      if (!userDoc.exists) {
        userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      }

      if (!userDoc.exists) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        await firebaseAuth.signOut();
        CommonSnackBar.getSnackBar(
          backgroundColor: Colors.red,
          title: "Login Error",
          message: "User account not found in database.",
        );
        return;
      }

      final data = userDoc.data()!;
      final bool isBlocked = data['isBlocked'] ?? false;
      final String role = (data['role'] ?? "patient").toString().toLowerCase().trim();

      if (isBlocked) {
        if (mounted) Navigator.of(context, rootNavigator: true).pop();
        await firebaseAuth.signOut();
        CommonSnackBar.getSnackBar(
          backgroundColor: Colors.red,
          title: "Access Denied",
          message: "This account has been blocked by Admin.",
        );
        return;
      }

      // Save session
      await storage.write('userid', user.uid);
      await storage.write('role', role);

      // Dismiss loader
      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      // Navigate
      if (role == "admin") {
        getIt<NavigationService>().goBackUntilAndPush(NavigationPath.adminPage);
      } else if (role == "doctor") {
        getIt<NavigationService>().goBackUntilAndPush(NavigationPath.doctorHomePage);
      } else {
        getIt<NavigationService>().goBackUntilAndPush(NavigationPath.homePage);
      }

    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      CommonSnackBar.getSnackBar(
        backgroundColor: Colors.red,
        title: "Login Failed",
        message: e.toString(),
      );
    }
  }

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
}
