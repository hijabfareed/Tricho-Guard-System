
import 'package:al_hair_app/generated/assets.dart';
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_icon_button.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:flutter/material.dart';

class CommonAppbar extends StatelessWidget {
  const CommonAppbar({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.isTitleShow = false,
    this.centerTitle = true,
    this.isbackButtonShow = false,
    this.actions,
    this.titleColor,
    this.backgroundColor,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final bool isTitleShow;
  final bool isbackButtonShow;
  final bool centerTitle;
  final List<Widget>? actions;
  final Color? titleColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: isbackButtonShow
          ? leading ??
              CommonIconButton(
                iconName: Assets.svgBackIcon,
                iconColor: AppColors.primaryColorWhite,
                isSvg: true,
                isOnlyBackgroundColor: true,
                radius: 10.0,
                iconHeight: 15.0,
                height: 35,
                width: 35,
                backgroundColor: AppColors.transparent,
                borderColor: AppColors.transparent,
                onTap: () {
                  getIt<NavigationService>().goBack();
                },
              ).paddingOnly(left: 15)
          : null,
      backgroundColor: backgroundColor ?? AppColors.transparent,
      centerTitle: centerTitle,
      leadingWidth: 30,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: isTitleShow
          ? title ??
              Text(
                titleText ?? "",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
              )
          : null,
      actions: actions,
    ).paddingOnly(top: 10.0);
  }
}
