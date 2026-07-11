import 'package:flutter/cupertino.dart';

extension SpaceHW on double {
  SizedBox get spaceH => SizedBox(
        height: this,
      );

  SizedBox get spaceW => SizedBox(
        width: this,
      );
}

extension WidgetExtension on Widget {
  Widget horizontalPadding(double padding) => Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: this,
      );

  Widget center() => Center(child: this);

  Widget leftAlign() => Align(
        alignment: Alignment.topLeft,
        child: this,
      );

  Widget bottomCenter() => Align(
    alignment: Alignment.bottomCenter,
    child: this,
  );

  Widget rightAlign() => Align(
        alignment: Alignment.topRight,
        child: this,
      );

  Widget paddingOnly({double left = 0.0, double right = 0.0, double top = 0.0, double bottom = 0.0}) => Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: this);

  Widget paddingSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingAll(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );

}
