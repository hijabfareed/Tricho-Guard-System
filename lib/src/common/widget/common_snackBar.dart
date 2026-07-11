import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonSnackBar {
  CommonSnackBar._();

  static getSnackBar({
    Color? backgroundColor,
    required String message,
    required String title,
  }) {
    // Ensure overlay/context exists
    if (Get.context == null || Get.overlayContext == null) {
      debugPrint('⚠️ Snackbar skipped: No context/overlay available');
      return;
    }

    // Delay a bit if overlay was just dismissed (e.g., after closing a dialog)
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor ?? Colors.black87,
        colorText: AppColors.primaryColorWhite,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      );
    });
  }
}
