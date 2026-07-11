// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

import '../networks/dio_client.dart' as _i4;
import '../networks/interceptors/tab_interceptor.dart' as _i7;
import '../networks/tab_api_client.dart' as _i5;
import '../services/navigation_service.dart' as _i6;
import 'register_services_module.dart' as _i8;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerServicesModule = _$RegisterServicesModule();
  await gh.factoryAsync<_i3.SharedPreferences>(
    () => registerServicesModule.prefs,
    preResolve: true,
  );
  gh.lazySingleton<_i4.DioClient>(() => registerServicesModule.dioClient);
  gh.lazySingleton<_i5.TabApiClient>(() => registerServicesModule.tabApiClient);
  gh.lazySingleton<_i6.NavigationService>(
      () => registerServicesModule.navigationService);
  gh.lazySingleton<_i7.TabInterceptor>(() => _i7.TabInterceptor());
  return getIt;
}

class _$RegisterServicesModule extends _i8.RegisterServicesModule {}
