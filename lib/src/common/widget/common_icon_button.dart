
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    this.onTap,
    required this.iconName,
    this.height = 48.0,
    this.isSvg = true,
    this.width = 48.0,
    this.radius = 30.0,
    this.iconHeight = 24.0,
    this.iconWidth = 24.0,
    this.backgroundColor,
    this.iconColor,
    this.hasBorder = true,
    this.borderColor,
    this.isGradient = true,
    this.isOnlyBackgroundColor = true,
  });

  final void Function()? onTap;
  final double height;
  final double width;
  final bool isSvg;
  final double radius;
  final double iconHeight;
  final double iconWidth;
  final Color? backgroundColor;
  final Color? iconColor;
  final String iconName;
  final bool hasBorder;
  final Color? borderColor;
  final bool isGradient;
  final bool isOnlyBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isOnlyBackgroundColor
          ? Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(radius),
            border: hasBorder
                ? Border.all(
              color: borderColor ?? AppColors.primaryRed,
            )
                : null),
        child: Center(
          child: isSvg
              ? SvgPicture.asset(
            iconName,
            height: iconHeight,
            width: iconWidth,
            color: iconColor,
          )
              : Image.asset(
            iconName,
            height: iconHeight,
            width: iconWidth,
            color: iconColor,
          ),
        ),
      )
          : Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: borderColor,
          borderRadius: BorderRadius.circular(radius),
          gradient: isGradient
              ? const LinearGradient(
            colors: [
              Color(0xff00B7E8),
              Color(0xff04BC75),
              Color(0xffFFDA00),
              Color(0xffD30F0F),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
        ),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              // shape: BoxShape.circle,
              borderRadius: BorderRadius.circular(radius),
              border: hasBorder
                  ? Border.all(
                color: borderColor ?? AppColors.primaryColorWhite,
              )
                  : null),
          child: Center(
            child: isSvg
                ? SvgPicture.asset(
              iconName,
              height: iconHeight,
              width: iconWidth,
              color: iconColor,
            )
                : Image.asset(
              iconName,
              height: iconHeight,
              width: iconWidth,
              color: iconColor,
            ),
          ),
        ).paddingOnly(top: 1.0, left: 1.0, right: 1.0, bottom: 5.0),
      ),
    );
  }
}
