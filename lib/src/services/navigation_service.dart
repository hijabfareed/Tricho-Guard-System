import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, { dynamic data}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: data);
  }

  goBack({String argument = ''}) {
    if(argument.isNotEmpty)
    {
      return navigatorKey.currentState!.pop(argument);
    }
    return navigatorKey.currentState!.pop();
  }

  /// 🟢 Fixed navigation to properly clear the stack
  goBackUntilAndPush(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }


  Route createRoute(destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
  Route createPopUp(destination) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      opaque: false,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, -1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}