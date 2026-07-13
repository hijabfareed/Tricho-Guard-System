import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_scaffold.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/constants/navigation_path.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page!.round();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            const Text(
              "Skip",
              style: TextStyle(
                color: Color(0xffA1A8B0),
                fontSize: 14.0,
              ),
            ).rightAlign().paddingOnly(left: 25.0, right: 25.0, top: 50.0),
            SizedBox(
              height: MediaQuery.sizeOf(context).height / 2.0,
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Image.asset(
                    Assets.imagesOnboarding1,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                  Image.asset(
                    Assets.imagesOnboarding2,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.broken_image_outlined, size: 48),
                    ),
                  ),
                ],
              ),
            ).paddingOnly(left: 20.0, right: 20.0, bottom: 80.0).center(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  currentPage == 0 ? "Smart Scalp Health Start Here" : "Get advice only from a doctor you believe in.",
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                15.0.spaceH,
                Row(
                  children: [
                    Container(
                      height: 10.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: currentPage == 0 ? const Color(0xff407CE2) : const Color(0xff407CE2).withValues(alpha: 0.5),
                      ),
                    ),
                    5.0.spaceW,
                    Container(
                      height: 10.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        color: currentPage == 1 ? const Color(0xff407CE2) : const Color(0xff407CE2).withValues(alpha: 0.5),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (pageController.hasClients) {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                          if (currentPage == 1) {
                            getIt<NavigationService>().goBackUntilAndPush(NavigationPath.letStartPage);
                          }
                          setState(() {
                            currentPage = 1;
                          });
                        }
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: const BoxDecoration(
                          color: Color(0xff407CE2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          currentPage == 1 ? Icons.check : Icons.arrow_right_alt,
                          color: AppColors.primaryColorWhite,
                        ).paddingAll(10.0).center(),
                      ),
                    ),
                  ],
                ),
                15.0.spaceH,
              ],
            ).paddingOnly(left: 25.0, right: 25.0, bottom: 50.0),
          ],
        ),
      ),
    );
  }
}
