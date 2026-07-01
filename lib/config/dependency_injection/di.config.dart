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
import '../../features/login/domain/use_cases/save_user_use_case.dart' as _i71;
import '../../features/login/presentation/view_model/cubit/login_cubit.dart'
    as _i753;
import '../../features/main/presentation/view_model/cubit/home_cubit.dart'
    as _i679;
import '../../features/profile/api/api_client/profile_api_client.dart' as _i699;
import '../../features/profile/api/datasources/profile_remote_data_source_impl.dart'
    as _i4;
import '../../features/profile/data/datasources/profile_remote_data_source_contract.dart'
    as _i961;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/use_cases/change_password_use_case.dart'
    as _i266;
import '../../features/profile/domain/use_cases/edit_profile_use_case.dart'
    as _i199;
import '../../features/profile/domain/use_cases/get_profile_use_case.dart'
    as _i110;
import '../../features/profile/domain/use_cases/logout_use_case.dart' as _i332;
import '../../features/profile/domain/use_cases/upload_profile_photo_use_case.dart'
    as _i895;
import '../../features/profile/presentation/view_model/cubit/profile_cubit.dart'
    as _i967;
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
    gh.factory<_i395.LoginApiClient>(
      () => _i395.LoginApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i699.ProfileApiClient>(
      () => _i699.ProfileApiClient(gh<_i361.Dio>()),
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
    gh.factory<_i961.ProfileRemoteDataSourceContract>(
      () => _i4.ProfileRemoteDataSourceImpl(gh<_i699.ProfileApiClient>()),
    );
    gh.factory<_i894.ProfileRepositoryContract>(
      () => _i334.ProfileRepositoryImpl(
        gh<_i961.ProfileRemoteDataSourceContract>(),
      ),
    );
    gh.factory<_i902.LoginRepositoryContract>(
      () => _i1066.LoginRepositoryImpl(
        gh<_i736.LoginRemoteDataSourceContract>(),
        gh<_i325.LoginLocalDataSourceContract>(),
      ),
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
    gh.factory<_i266.ChangePasswordUseCase>(
      () => _i266.ChangePasswordUseCase(gh<_i894.ProfileRepositoryContract>()),
    );
    gh.factory<_i199.EditProfileUseCase>(
      () => _i199.EditProfileUseCase(gh<_i894.ProfileRepositoryContract>()),
    );
    gh.factory<_i110.GetProfileUseCase>(
      () => _i110.GetProfileUseCase(gh<_i894.ProfileRepositoryContract>()),
    );
    gh.factory<_i332.LogoutUseCase>(
      () => _i332.LogoutUseCase(gh<_i894.ProfileRepositoryContract>()),
    );
    gh.factory<_i895.UploadProfilePhotoUseCase>(
      () => _i895.UploadProfilePhotoUseCase(
        gh<_i894.ProfileRepositoryContract>(),
      ),
    );
    gh.factory<_i967.ProfileCubit>(
      () => _i967.ProfileCubit(
        gh<_i110.GetProfileUseCase>(),
        gh<_i71.SaveUserUseCase>(),
        gh<_i199.EditProfileUseCase>(),
        gh<_i895.UploadProfilePhotoUseCase>(),
        gh<_i332.LogoutUseCase>(),
        gh<_i266.ChangePasswordUseCase>(),
      ),
    );
    gh.factory<_i753.LoginCubit>(
      () => _i753.LoginCubit(
        gh<_i191.LoginUseCase>(),
        gh<_i71.SaveUserUseCase>(),
      ),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
