
import 'dart:ui';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/material.dart';

class CommonDialog{

// Show custom dialog with specific page
  static Future showCustomDialog(
    BuildContext context,
    Widget child, {
    EdgeInsets? margin,
    bool barrierDismissible = true,
    Color? backgroundColor,
    double? height,
    double? heightLand,
    double? borderRadius,
    bool showCloseBtn = true
  }) async {
    return showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: barrierDismissible,
        barrierColor: AppColors.primaryColorBlack.withValues(alpha: 0.5),
        builder: (ctx) {
          return OrientationBuilder(builder: (context, orientation) {
            return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: AppColors.transparentColor,
                    body: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 30,
                            ),
// height: ScreenUtil().orientation == Orientation.portrait ? height : heightLand,
                            clipBehavior: Clip.hardEdge,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(borderRadius ?? 20),
                              color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // showCloseBtn?CommonIconButton(
                                    //   iconName: Assets.svgClose,
                                    //   iconWidth: 10,
                                    //   iconHeight: 10,
                                    //   width: 30,
                                    //   height: 30,
                                    //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                    //   iconColor: AppColors.primaryColorRed,
                                    //   onTap: () {
                                    //     getIt<NavigationService>().goBack();
                                    //   },
                                    // ).paddingAll(AppDimensions.diem6):const SizedBox(height: 10,),
                                  ],
                                ),
                                child,
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ));
          });
        });
  }
}