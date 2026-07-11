import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_button.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:flutter/material.dart';

class LetStartPage extends StatefulWidget {
  const LetStartPage({super.key});

  @override
  State<LetStartPage> createState() => _LetStartPageState();
}

class _LetStartPageState extends State<LetStartPage> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            Assets.imagesLogo1,
            height: 300,
          ).center(),
          const Text(
            "Let’s get started!",
            style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          10.0.spaceH,
          Text(
            "Login to Stay healthy and fit ",
            style: TextStyle(
              fontSize: 16.0,
              color: const Color(0xff221F1F).withValues(alpha: 0.5),
              fontWeight: FontWeight.w400,
            ),
          ),

          25.0.spaceH,
          CommonButton(
            title: "Login",
            onTap: (){
              getIt<NavigationService>().navigateTo(NavigationPath.loginPage);
            },
          ),
          10.0.spaceH,
           CommonButton(
            title: "Sign Up",
            buttonType: ButtonType.simple,
             onTap: (){
               getIt<NavigationService>().navigateTo(NavigationPath.signupPage);
             },
          ),
          25.0.spaceH,
        ],
      ).paddingOnly(left: 25.0, right: 25.0),
    );
  }
}
