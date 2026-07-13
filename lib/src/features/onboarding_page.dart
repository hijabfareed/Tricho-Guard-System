import 'package:al_hair_app/generated/assets.dart';
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
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<_OnboardingSlide> _slides = const [
    _OnboardingSlide(
      imagePath: Assets.imagesBg1,
      title: 'Smart Scalp Health\nStarts Here',
      description:
          'AI-assisted scalp analysis with clear insights, trusted guidance, and care plans built around you.',
    ),
    _OnboardingSlide(
      imagePath: Assets.imagesOnboarding2,
      title: 'Advice From Trusted\nDoctors Only',
      description:
          'Connect with verified specialists and make confident decisions for treatment and recovery.',
    ),
  ];

  @override
  void initState() {
    pageController.addListener(() {
      final nextPage = pageController.page?.round() ?? 0;
      if (nextPage != currentPage && mounted) {
        setState(() {
          currentPage = nextPage;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (currentPage == _slides.length - 1) {
      getIt<NavigationService>()
          .goBackUntilAndPush(NavigationPath.letStartPage);
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CommonScaffold(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isDesktop = constraints.maxWidth >= 900;
            final double contentWidth = isDesktop ? 860 : constraints.maxWidth;
            final double imageHeight =
                isDesktop ? 440 : constraints.maxHeight * 0.5;

            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xff407CE2).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'TrichoGuard Onboarding',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: const Color(0xff2F6BD8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: imageHeight,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffF3F7FF), Color(0xffE6EEFF)],
                        ),
                      ),
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: _slides.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                _slides[index].imagePath,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image_outlined,
                                      size: 48),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _slides[currentPage].title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          color: const Color(0xff1B1F2A),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _slides[currentPage].description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: const Color(0xff5A6170),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                      child: Row(
                        children: [
                          ...List.generate(_slides.length, (index) {
                            final bool active = index == currentPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 8),
                              height: 8,
                              width: active ? 34 : 16,
                              decoration: BoxDecoration(
                                color: active
                                    ? const Color(0xff407CE2)
                                    : const Color(0xff9DBCF4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                          const Spacer(),
                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: _handleNext,
                            child: Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xff407CE2),
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33407CE2),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Icon(
                                currentPage == _slides.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward_rounded,
                                color: AppColors.primaryColorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final String imagePath;
  final String title;
  final String description;

  const _OnboardingSlide({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
