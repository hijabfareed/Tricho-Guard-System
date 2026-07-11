import 'package:flutter/material.dart';

import '../../constants/app_color.dart';

class CommonScaffold extends StatelessWidget {
  final Widget child;
  final Widget? image;
  final bool withDrawer;
  final Function(String coin)? drawerCallBack;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final ValueNotifier<double>? dyValueNotifier;
  final bool isMoving;
  final bool tradeBackground;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final Color? appbarBackgroundColor;
  final bool hasBlurBackground;
  final PreferredSize? appBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  // App bar variables
  final bool withBackButton;
  final bool extendBodyBehindAppBar;
  final List<Widget>? actions;
  final Widget? title;
  final Widget? leading;
  final Widget? drawer;
  final bool withAppBar;
  final bool withDivider;
  final bool isShowDrawer;

  const CommonScaffold({
    required this.child,
    this.withDrawer = false,
    this.image,
    this.drawer,
    this.drawerCallBack,
    this.scaffoldKey,
    this.bottomNavigationBar,
    this.bottomSheet,
    super.key,
    this.dyValueNotifier,
    this.appbarBackgroundColor,
    this.isMoving = false,
    this.tradeBackground = false,
    this.topSafeArea = true,
    this.bottomSafeArea = false,
    this.hasBlurBackground = false,
    this.backgroundColor,
    this.appBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.withBackButton = false,
    this.actions,
    this.title,
    this.leading,
    this.withAppBar = false,
    this.withDivider = true,
    this.extendBodyBehindAppBar = false,
    this.isShowDrawer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: isShowDrawer ? drawer : null,
      drawerEnableOpenDragGesture: false,
      appBar: withAppBar
          ? appBar ??  PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          centerTitle: true,
          title: title,
          actions: actions,
          elevation: 0.0,
          backgroundColor: appbarBackgroundColor ?? AppColors.primaryColorWhite,
          leading: leading,
        ),
      )
          : null,
      floatingActionButton: floatingActionButton,
      backgroundColor: backgroundColor ?? AppColors.primaryColorWhite,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      body: child,
    );
  }
}
