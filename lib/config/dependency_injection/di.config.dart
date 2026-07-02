// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../core/api/datasources/auth_local_data_source_impl.dart' as _i424;
import '../../core/data/data_sources/auth_local_data_source.dart' as _i759;
import '../../features/auth_module/api/api_client/auth_module_api_client.dart'
    as _i419;
import '../../features/auth_module/api/datasources/auth_module_local_data_source_impl.dart'
    as _i1034;
import '../../features/auth_module/api/datasources/auth_module_remote_data_source_impl.dart'
    as _i428;
import '../../features/auth_module/data/datasources/auth_module_local_data_source_contract.dart'
    as _i435;
import '../../features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart'
    as _i72;
import '../../features/auth_module/data/repositories/auth_module_repository_impl.dart'
    as _i848;
import '../../features/auth_module/domain/repositories/auth_module_repository.dart'
    as _i1015;
import '../../features/auth_module/domain/use_cases/delete_driver_credentials_use_case.dart'
    as _i935;
import '../../features/auth_module/domain/use_cases/get_saved_credentials_use_case.dart'
    as _i766;
import '../../features/auth_module/domain/use_cases/login_driver_use_case.dart'
    as _i645;
import '../../features/auth_module/domain/use_cases/logout_driver_use_case.dart'
    as _i413;
import '../../features/auth_module/domain/use_cases/save_driver_credentials_use_case.dart'
    as _i915;
import '../../features/auth_module/domain/use_cases/save_driver_token_use_case.dart'
    as _i549;
import '../../features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart'
    as _i575;
import '../../features/login/api/api_client/login_api_client.dart' as _i395;
import '../../features/login/api/datasources/login_local_data_source_impl.dart'
    as _i438;
import '../../features/login/api/datasources/login_remote_data_source_impl.dart'
    as _i904;
import '../../features/login/data/datasources/login_local_data_source_contract.dart'
    as _i325;
import '../../features/login/data/datasources/login_remote_data_source_contract.dart'
    as _i736;
import '../../features/login/data/repositories/login_repository_impl.dart'
    as _i1066;
import '../../features/login/domain/repositories/login_repository.dart'
    as _i902;
import '../../features/login/domain/use_cases/get_user_use_case.dart' as _i12;
import '../../features/login/domain/use_cases/login_use_case.dart' as _i191;
import '../../features/login/domain/use_cases/save_token_use_case.dart'
    as _i113;
import '../../features/login/domain/use_cases/save_user_use_case.dart' as _i71;
import '../../features/login/presentation/view_model/cubit/login_cubit.dart'
    as _i753;
import '../../features/main/presentation/view_model/cubit/home_cubit.dart'
    as _i679;
import '../../features/main_profile/api/api_client/main_profile_api_client.dart'
    as _i89;
import '../../features/main_profile/api/datasources/main_profile_remote_data_source_impl.dart'
    as _i522;
import '../../features/main_profile/data/datasources/main_profile_remote_data_source_contract.dart'
    as _i525;
import '../../features/main_profile/data/repositories/main_profile_repository_impl.dart'
    as _i164;
import '../../features/main_profile/domain/repositories/main_profile_repository.dart'
    as _i488;
import '../../features/main_profile/domain/use_cases/get_main_profile_use_case.dart'
    as _i818;
import '../../features/main_profile/presentation/view_model/cubit/main_profile_cubit.dart'
    as _i60;
import '../api/app_interceptor.dart' as _i449;
import '../api/dio_module.dart' as _i784;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i361.Dio>(() => dioModule.dio());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => dioModule.secureStorage(),
    );
    gh.lazySingleton<_i361.CancelToken>(() => dioModule.cancelToken());
    gh.lazySingleton<_i161.InternetConnection>(
      () => dioModule.internetConnection(),
    );
    gh.lazySingleton<_i679.HomeCubit>(() => _i679.HomeCubit());
    gh.factory<_i435.AuthModuleLocalDataSourceContract>(
      () => _i1034.AuthModuleLocalDataSourceImpl(),
    );
    gh.factory<_i419.AuthModuleApiClient>(
      () => _i419.AuthModuleApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i395.LoginApiClient>(
      () => _i395.LoginApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i89.MainProfileApiClient>(
      () => _i89.MainProfileApiClient(gh<_i361.Dio>()),
    );
    gh.singleton<_i449.AppInterceptors>(
      () => _i449.AppInterceptors(
        dio: gh<_i361.Dio>(),
        fss: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i325.LoginLocalDataSourceContract>(
      () => _i438.LoginLocalDataSourceImpl(),
    );
    gh.lazySingleton<_i759.AuthLocalDataSourceContract>(
      () =>
          _i424.AuthLocalDataSourceImpl(fss: gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i736.LoginRemoteDataSourceContract>(
      () => _i904.LoginRemoteDataSourceImpl(gh<_i395.LoginApiClient>()),
    );
    gh.factory<_i72.AuthModuleRemoteDataSourceContract>(
      () =>
          _i428.AuthModuleRemoteDataSourceImpl(gh<_i419.AuthModuleApiClient>()),
    );
    gh.factory<_i525.MainProfileRemoteDataSourceContract>(
      () => _i522.MainProfileRemoteDataSourceImpl(
        gh<_i89.MainProfileApiClient>(),
      ),
    );
    gh.factory<_i1015.AuthModuleRepository>(
      () => _i848.AuthModuleRepositoryImpl(
        gh<_i72.AuthModuleRemoteDataSourceContract>(),
        gh<_i435.AuthModuleLocalDataSourceContract>(),
      ),
    );
    gh.factory<_i935.DeleteDriverCredentialsUseCase>(
      () => _i935.DeleteDriverCredentialsUseCase(
        gh<_i1015.AuthModuleRepository>(),
      ),
    );
    gh.factory<_i766.GetSavedCredentialsUseCase>(
      () => _i766.GetSavedCredentialsUseCase(gh<_i1015.AuthModuleRepository>()),
    );
    gh.factory<_i645.LoginDriverUseCase>(
      () => _i645.LoginDriverUseCase(gh<_i1015.AuthModuleRepository>()),
    );
    gh.factory<_i413.LogoutDriverUseCase>(
      () => _i413.LogoutDriverUseCase(gh<_i1015.AuthModuleRepository>()),
    );
    gh.factory<_i915.SaveDriverCredentialsUseCase>(
      () =>
          _i915.SaveDriverCredentialsUseCase(gh<_i1015.AuthModuleRepository>()),
    );
    gh.factory<_i549.SaveDriverTokenUseCase>(
      () => _i549.SaveDriverTokenUseCase(gh<_i1015.AuthModuleRepository>()),
    );
    gh.factory<_i488.MainProfileRepositoryContract>(
      () => _i164.MainProfileRepositoryImpl(
        gh<_i525.MainProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i902.LoginRepositoryContract>(
      () => _i1066.LoginRepositoryImpl(
        gh<_i736.LoginRemoteDataSourceContract>(),
        gh<_i325.LoginLocalDataSourceContract>(),
      ),
    );
    gh.factory<_i575.AuthModuleCubit>(
      () => _i575.AuthModuleCubit(
        gh<_i645.LoginDriverUseCase>(),
        gh<_i413.LogoutDriverUseCase>(),
        gh<_i766.GetSavedCredentialsUseCase>(),
        gh<_i549.SaveDriverTokenUseCase>(),
        gh<_i915.SaveDriverCredentialsUseCase>(),
        gh<_i935.DeleteDriverCredentialsUseCase>(),
      ),
    );
    gh.factory<_i113.SaveTokenUseCase>(
      () => _i113.SaveTokenUseCase(gh<_i902.LoginRepositoryContract>()),
    );
    gh.factory<_i12.GetUserUseCase>(
      () => _i12.GetUserUseCase(gh<_i902.LoginRepositoryContract>()),
    );
    gh.factory<_i191.LoginUseCase>(
      () => _i191.LoginUseCase(gh<_i902.LoginRepositoryContract>()),
    );
    gh.factory<_i71.SaveUserUseCase>(
      () => _i71.SaveUserUseCase(gh<_i902.LoginRepositoryContract>()),
    );
    gh.factory<_i818.GetMainProfileUseCase>(
      () => _i818.GetMainProfileUseCase(
        gh<_i488.MainProfileRepositoryContract>(),
      ),
    );
    gh.factory<_i753.LoginCubit>(
      () => _i753.LoginCubit(
        gh<_i191.LoginUseCase>(),
        gh<_i71.SaveUserUseCase>(),
        gh<_i113.SaveTokenUseCase>(),
      ),
    );
    gh.factory<_i60.MainProfileCubit>(
      () => _i60.MainProfileCubit(
        gh<_i818.GetMainProfileUseCase>(),
        gh<_i71.SaveUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
