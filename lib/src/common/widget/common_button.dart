import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    this.onTap,
    this.buttonType = ButtonType.gradient,
    this.width,
    this.height,
    this.isIcon = false,
    this.iconName,
  });

  final String title;
  final void Function()? onTap;
  final ButtonType buttonType;
  final double? height;
  final double? width;
  final bool isIcon;
  final String? iconName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: buttonCase(buttonType, context),
    );
  }

  Widget buttonCase(ButtonType type, BuildContext context) {
    switch (type) {
      case ButtonType.gradient:
        return Container(
          width: width ?? MediaQuery.sizeOf(context).width,
          height: height ?? 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.0),
            gradient: const LinearGradient(
              colors: [
                Color(0xff407CE2),
                Color(0xff407CE2),
              ],
              stops: [0.0, 1.0],
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
              tileMode: TileMode.repeated,
            ),
          ),
          child: isIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(iconName! , height: 20.0,width: 20.0,),
                    10.0.spaceW,
                    Text(
                      title,
                      style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColorWhite,
                          ),
                    )
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColorWhite,
                      ),
                ).center(),
        );
      case ButtonType.lessGradient:
        return Container(
          padding: const EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xff407CE2).withValues(alpha: 0.1),
                const Color(0xff407CE2).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(200),
          ),
          child: Container(
            alignment: Alignment.center,
            width: width ?? MediaQuery.sizeOf(context).width,
            height: height ?? 40.0,
            decoration: BoxDecoration(
              // color: AppColors.primaryColorWhite,
              borderRadius: BorderRadius.circular(200),
            ),
            child: isIcon
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(iconName!,height: 20.0,width: 20.0,),
                      10.0.spaceW,
                      Text(
                        title,
                        style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColorWhite,
                            ),
                      )
                    ],
                  )
                : Text(
                    title,
                    style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColorWhite,
                        ),
                  ).center(),
          ),
        );
      case ButtonType.simple:
        return Container(
          width: width ?? MediaQuery.sizeOf(context).width,
          height: height ?? 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.0),
            border: Border.all(
              color: const Color(0xff407CE2),
            ),
          ),
          child: isIcon
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(iconName! , height: 20.0,width: 20.0,),
                    10.0.spaceW,
                    Text(
                      title,
                      style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xff407CE2),
                          ),
                    )
                  ],
                )
              : Text(
                  title,
                  style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xff407CE2),
                      ),
                ).center(),
        );
    }
  }
}

enum ButtonType {
  gradient,
  lessGradient,
  simple,
}
