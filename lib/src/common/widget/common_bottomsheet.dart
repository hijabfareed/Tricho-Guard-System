import 'dart:ui';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/material.dart';

class CommonBottomSheet {
  // Show custom bottom sheet with specific page
  static Future showBottomSheet(
      BuildContext context,
      Widget child, {
        BorderRadius? borderRadius,
        bool isScrollControlled = false,
        bool isDismissible = false,
        double? height,
        bool expanded = true,
        EdgeInsets? margin,
        bool isFloat = false,
        Color? backgroundColor,
        String? bgImage,
        bool isBlur = false,
        bool hasShadowStyle = false,
        enableDrag=true,
        Function()? onClose,
      }) async {
    return await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag:enableDrag,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2),
      isDismissible: isDismissible,
      backgroundColor: isFloat ? AppColors.transparentColor : backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      builder: (BuildContext context) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16 + 10),
              ),
              child: Stack(
                children: [
                  ImageFiltered(
                    imageFilter: isBlur ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16 + 10),
                        ),
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
