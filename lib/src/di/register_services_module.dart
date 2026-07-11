
import 'package:al_hair_app/src/di/service_locator.dart';
import 'package:al_hair_app/src/networks/dio_client.dart';
import 'package:al_hair_app/src/networks/interceptors/tab_interceptor.dart';
import 'package:al_hair_app/src/networks/tab_api_client.dart';
import 'package:al_hair_app/src/services/navigation_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';


@module
abstract class RegisterServicesModule {

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  DioClient get dioClient => DioClient();

  @lazySingleton
  TabApiClient get tabApiClient => TabApiClient(dioClient.getDioClient(getIt<TabInterceptor>()), baseUrl: DioClient.baseUrl);

  @lazySingleton
  NavigationService get navigationService => NavigationService();


}