
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class TabInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    @override
    void onRequest(
        RequestOptions options, RequestInterceptorHandler handler) async {
      // var token = getIt<SharedPreferencesStorage>().oAuthToken;
      // if (token != null && token.isNotEmpty) {
      //   options.headers
      //       .putIfAbsent(HttpHeaders.authorizationHeader, () => "Bearer ${token}");
      //  // options.queryParameters.putIfAbsent('auth', () => token);
      //   super.onRequest(options, handler);
      //   return;
      // }
      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // when user getting 401 or 403, dialog appear and redirect to home page
    // TODO || err.response?.statusCode == 403
    if ((err.response?.statusCode == 401)) {
      // Because the login page call update controller for bottom navigation bar,
      // then when it updated, the initState for stake page called, then api
      // called then the apis return 401, that is why getting session expired two time
      // if(getIt<SharedPreferencesStorage>().isLoggedIn??false){
      //   SharedPreferences preferences = await SharedPreferences.getInstance();
      //   await preferences.clear();
      //
      //   getIt<NavigationService>().goBackUntilAndPush(NavigationPath.login);
      //
      //
      //
      //   CommonDialog.showCustomDialog(
      //     getIt<NavigationService>().navigatorKey.currentContext!,
      //     SuccessWidget(
      //       title: S.of(getIt<NavigationService>().navigatorKey.currentContext!).ops_the_session_is_expired,
      //       image: Lottie.asset(
      //         Assets.lottieExpired,
      //         height: 150,
      //         width: 150,
      //         fit: BoxFit.contain,
      //       ),
      //       onTap: () {
      //         getIt<NavigationService>().goBack();
      //       },
      //     ),
      //   );
      // }
    }

    return handler.reject(err);
  }

// @override
// void onResponse(Response response, ResponseInterceptorHandler handler)async {
//   CommonDialog.showCustomDialog(
//     getIt<NavigationService>().navigatorKey.currentContext!,
//     SuccessWidget(
//       title: S.of(getIt<NavigationService>().navigatorKey.currentContext!).ops_the_session_is_expired,
//       image:   Lottie.asset(
//         Assets.lottieExpired,
//         height: 150,
//         width: 150,
//         fit: BoxFit.contain,
//       ),
//       onTap: () {
//         getIt<NavigationService>().goBack();
//       },
//     ),
//   );
// }
}
