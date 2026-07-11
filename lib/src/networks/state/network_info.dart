//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class NetworkInfoCubit extends Cubit<ConnectivityResult> {
//   NetworkInfoCubit(Connectivity _connectivityService)
//       : super(ConnectivityResult.wifi) {
//     initConnectivity();
//     _connectivityService.onConnectivityChanged.listen((event) {
//       connectionChanged(event);
//     });
//   }
//   connectionChanged(ConnectivityResult result) {
//     emit(result);
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initConnectivity() async {
//     late ConnectivityResult result;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       result = await Connectivity().checkConnectivity();
//     } on PlatformException catch (e) {
//       //developer.log('Couldn\'t check connectivity status', error: e);
//       return;
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     // if (!mounted) {
//     //   return Future.value(null);
//     // }
//
//     return connectionChanged(result);
//   }
//
// }
//
// bool isConnected(ConnectivityResult connection) =>
//     connection == ConnectivityResult.wifi || connection == ConnectivityResult.mobile;