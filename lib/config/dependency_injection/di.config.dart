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
import '../../features/driver_orders/api/api_client/driver_orders_api_client.dart'
    as _i817;
import '../../features/driver_orders/api/data_sources/driver_orders_remote_data_source_impl.dart'
    as _i1049;
import '../../features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart'
    as _i565;
import '../../features/driver_orders/data/repositories/driver_orders_repository_impl.dart'
    as _i356;
import '../../features/driver_orders/domain/repositories/driver_orders_repository.dart'
    as _i542;
import '../../features/driver_orders/domain/use_cases/accept_order_use_case.dart'
    as _i738;
import '../../features/driver_orders/domain/use_cases/complete_order_use_case.dart'
    as _i508;
import '../../features/driver_orders/domain/use_cases/get_active_order_use_case.dart'
    as _i911;
import '../../features/driver_orders/domain/use_cases/get_my_orders_use_case.dart'
    as _i468;
import '../../features/driver_orders/domain/use_cases/get_pending_orders_use_case.dart'
    as _i453;
import '../../features/driver_orders/domain/use_cases/reject_order_use_case.dart'
    as _i247;
import '../../features/driver_orders/domain/use_cases/start_order_use_case.dart'
    as _i545;
import '../../features/driver_orders/presentation/cubit/driver_orders_cubit.dart'
    as _i249;
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
import '../../features/orders/api/api_client/orders_api_client.dart' as _i107;
import '../../features/orders/api/datasources/orders_remote_data_source_impl.dart'
    as _i335;
import '../../features/orders/data/datasources/orders_remote_data_source_contract.dart'
    as _i586;
import '../../features/orders/data/repositories/orders_repository_impl.dart'
    as _i368;
import '../../features/orders/domain/repositories/orders_repository.dart'
    as _i992;
import '../../features/orders/domain/use_cases/get_orders_use_case.dart'
    as _i755;
import '../../features/orders/presentation/view_model/cubit/orders_cubit.dart'
    as _i871;
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
    gh.factory<_i89.MainProfileApiClient>(
      () => _i89.MainProfileApiClient(gh<_i361.Dio>()),
    );
    gh.factory<_i107.OrdersApiClient>(
      () => _i107.OrdersApiClient(gh<_i361.Dio>()),
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
    gh.lazySingleton<_i817.DriverOrdersApiClient>(
      () => _i817.DriverOrdersApiClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i759.AuthLocalDataSourceContract>(
      () =>
          _i424.AuthLocalDataSourceImpl(fss: gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i736.LoginRemoteDataSourceContract>(
      () => _i904.LoginRemoteDataSourceImpl(gh<_i395.LoginApiClient>()),
    );
    gh.factory<_i525.MainProfileRemoteDataSourceContract>(
      () => _i522.MainProfileRemoteDataSourceImpl(
        gh<_i89.MainProfileApiClient>(),
      ),
    );
    gh.factory<_i586.OrdersRemoteDataSourceContract>(
      () => _i335.OrdersRemoteDataSourceImpl(gh<_i107.OrdersApiClient>()),
    );
    gh.lazySingleton<_i565.DriverOrdersRemoteDataSourceContract>(
      () => _i1049.DriverOrdersRemoteDataSourceImpl(
        apiClient: gh<_i817.DriverOrdersApiClient>(),
      ),
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
    gh.factory<_i992.OrdersRepositoryContract>(
      () => _i368.OrdersRepositoryImpl(
        gh<_i586.OrdersRemoteDataSourceContract>(),
      ),
    );
    gh.lazySingleton<_i542.DriverOrdersRepository>(
      () => _i356.DriverOrdersRepositoryImpl(
        remoteDataSource: gh<_i565.DriverOrdersRemoteDataSourceContract>(),
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
    gh.factory<_i738.AcceptOrderUseCase>(
      () => _i738.AcceptOrderUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i508.CompleteOrderUseCase>(
      () => _i508.CompleteOrderUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i911.GetActiveOrderUseCase>(
      () => _i911.GetActiveOrderUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i468.GetMyOrdersUseCase>(
      () => _i468.GetMyOrdersUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i453.GetPendingOrdersUseCase>(
      () => _i453.GetPendingOrdersUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i247.RejectOrderUseCase>(
      () => _i247.RejectOrderUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i545.StartOrderUseCase>(
      () => _i545.StartOrderUseCase(gh<_i542.DriverOrdersRepository>()),
    );
    gh.factory<_i818.GetMainProfileUseCase>(
      () => _i818.GetMainProfileUseCase(
        gh<_i488.MainProfileRepositoryContract>(),
      ),
    );
    gh.factory<_i755.GetOrdersUseCase>(
      () => _i755.GetOrdersUseCase(gh<_i992.OrdersRepositoryContract>()),
    );
    gh.factory<_i249.DriverOrdersCubit>(
      () => _i249.DriverOrdersCubit(
        getPendingOrdersUseCase: gh<_i453.GetPendingOrdersUseCase>(),
        getMyOrdersUseCase: gh<_i468.GetMyOrdersUseCase>(),
        getActiveOrderUseCase: gh<_i911.GetActiveOrderUseCase>(),
        acceptOrderUseCase: gh<_i738.AcceptOrderUseCase>(),
        rejectOrderUseCase: gh<_i247.RejectOrderUseCase>(),
        startOrderUseCase: gh<_i545.StartOrderUseCase>(),
        completeOrderUseCase: gh<_i508.CompleteOrderUseCase>(),
      ),
    );
    gh.factory<_i753.LoginCubit>(
      () => _i753.LoginCubit(
        gh<_i191.LoginUseCase>(),
        gh<_i71.SaveUserUseCase>(),
      ),
    );
    gh.factory<_i60.MainProfileCubit>(
      () => _i60.MainProfileCubit(
        gh<_i818.GetMainProfileUseCase>(),
        gh<_i71.SaveUserUseCase>(),
      ),
    );
    gh.factory<_i871.OrdersCubit>(
      () => _i871.OrdersCubit(gh<_i755.GetOrdersUseCase>()),
    );
    return this;
  }
}

class _$DioModule extends _i784.DioModule {}
