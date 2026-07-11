import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_dialog.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/common/widget/common_snackBar.dart';
import 'package:al_hair_app/src/common/widget/common_text_field.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      withAppBar: true,
      title: const Text(
        "Forgot Password",
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    50.0.spaceH,
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ).leftAlign(),
                    20.0.spaceH,
                    CommonTextField(
                      controller: email,
                      borderColor: AppColors.lightGray.withValues(alpha: 0.4),
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: SvgPicture.asset(Assets.imagesEmail).paddingAll(10.0),
                      radius: 10.0,
                      hintText: "Enter Your Email",
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(v)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ).paddingOnly(left: 25.0, right: 25.0),
              ),
            ),
            20.0.spaceH,
            CommonButton(
              title: "Continue",
              onTap: () {
                if (email.text.isEmpty) {
                  CommonSnackBar.getSnackBar(backgroundColor: Colors.blueAccent, message: 'Please fill All requirement', title: 'Info');
                } else {
                  forgotPasswordFunction();
                }
              },
            ).paddingOnly(left: 25.0, right: 25.0),
            50.0.spaceH,
          ],
        ),
      ),
    );
  }

  Future<void> forgotPasswordFunction() async {
    try {
      _showDialogConnecting();
      await firebaseAuth
          .sendPasswordResetEmail(
        email: email.text,
      )
          .then((result) async {
        getIt<NavigationService>().goBack();
        getIt<NavigationService>().goBack();
        CommonSnackBar.getSnackBar(backgroundColor: Colors.green, message: "Please Check Your Mail", title: 'Success');
      });
    } catch (err) {
      getIt<NavigationService>().goBack();
      CommonSnackBar.getSnackBar(backgroundColor: Colors.red, message: err.toString(), title: 'Error');
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
          size: 50.0,
        ).center(),
      ),
    );
  }
}
