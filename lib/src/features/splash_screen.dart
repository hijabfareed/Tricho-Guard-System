import 'dart:async';

import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;

      final String? userId = storage.read('userid');
      final String? role = storage.read('role');

      /// 🔒 USER NOT LOGGED IN
      if (userId == null) {
        getIt<NavigationService>()
            .goBackUntilAndPush(NavigationPath.onboardingPage);
        return;
      }

      /// 👑 ADMIN
      if (role == 'admin') {
        getIt<NavigationService>()
            .goBackUntilAndPush(NavigationPath.adminPage);
        return;
      }

      /// 👨‍⚕️ DOCTOR (DERMATOLOGIST)
      if (role == 'doctor') {
        final doc = await FirebaseFirestore.instance
            .collection('dermatologists')
            .doc(userId)
            .get();

        if (!doc.exists) {
          /// profile not created yet
          getIt<NavigationService>()
              .goBackUntilAndPush(NavigationPath.addDermatologistProfilePage);
          return;
        }

        final status = doc.data()?['approvalStatus'];

        if (status == 'approved') {
          getIt<NavigationService>()
              .goBackUntilAndPush(NavigationPath.doctorHomePage);
        } else {
          /// pending OR rejected → still doctor dashboard
          /// (dashboard itself will block via dialog)
          getIt<NavigationService>()
              .goBackUntilAndPush(NavigationPath.doctorHomePage);
        }
        return;
      }

      /// 👤 PATIENT / USER
      getIt<NavigationService>()
          .goBackUntilAndPush(NavigationPath.homePage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.imagesSplashBg1),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Image.asset(
            Assets.imagesLogo1,
            height: 350,
            width: 350,
          ).center(),
        ],
      ),
    );
  }
}
