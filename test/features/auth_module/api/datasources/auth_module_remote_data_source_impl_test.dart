import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/dependency_injection/di.dart';
import 'package:track_flowers_app/config/error_handling/failures.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/auth_module/api/datasources/auth_module_remote_data_source_impl.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';

import 'auth_module_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([AuthModuleApiClient, InternetConnection])
void main() {
  late AuthModuleRemoteDataSourceImpl dataSource;
  late MockAuthModuleApiClient mockApiClient;
  late MockInternetConnection mockInternetConnection;

  setUp(() {
    mockApiClient = MockAuthModuleApiClient();
    mockInternetConnection = MockInternetConnection();
    
    // Setup dependency injection for internet connection
    if (getIt.isRegistered<InternetConnection>()) {
      getIt.unregister<InternetConnection>();
    }
    getIt.registerSingleton<InternetConnection>(mockInternetConnection);
    
    // default behavior for internet connection
    when(mockInternetConnection.hasInternetAccess).thenAnswer((_) async => true);

    dataSource = AuthModuleRemoteDataSourceImpl(mockApiClient);
  });
  
  tearDown(() {
    getIt.reset();
  });

  group('loginDriver', () {
    const tRequest = DriverLoginRequestEntity(email: 'test@test.com', password: 'password', remember: true);
    final tResponseMap = {
      'message': 'Success',
      'token': 'test_token',
      'driver': {
        'id': '1',
        'name': 'Test',
        'email': 'test@test.com',
        'phone': '123456',
      }
    };

    test('should return Success with DriverLoginResponseModel when api call is successful', () async {
      // arrange
      when(mockApiClient.loginDriver(tRequest.email, tRequest.password))
          .thenAnswer((_) async => tResponseMap);

      // act
      final result = await dataSource.loginDriver(tRequest);

      // assert
      expect(result, isA<Success<DriverLoginResponseModel>>());
      final successResult = result as Success<DriverLoginResponseModel>;
      expect(successResult.data?.message, equals('Success'));
      expect(successResult.data?.token, equals('test_token'));
      verify(mockInternetConnection.hasInternetAccess).called(2);
      verify(mockApiClient.loginDriver(tRequest.email, tRequest.password)).called(1);
    });

    test('should return Error with ServerFailure when DioException is thrown', () async {
      // arrange
      final tDioException = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'Bad request'}
        ),
        type: DioExceptionType.badResponse,
      );
      when(mockApiClient.loginDriver(tRequest.email, tRequest.password))
          .thenThrow(tDioException);

      // act
      final result = await dataSource.loginDriver(tRequest);

      // assert
      expect(result, isA<Error<DriverLoginResponseModel>>());
      final errorResult = result as Error<DriverLoginResponseModel>;
      expect(errorResult.exception, isA<ServerFailure>());
      verify(mockInternetConnection.hasInternetAccess).called(2);
      verify(mockApiClient.loginDriver(tRequest.email, tRequest.password)).called(1);
    });

    test('should return Error with NetworkFailures when there is no internet connection', () async {
      // arrange
      when(mockInternetConnection.hasInternetAccess).thenAnswer((_) async => false);

      // act
      final result = await dataSource.loginDriver(tRequest);

      // assert
      expect(result, isA<Error<DriverLoginResponseModel>>());
      final errorResult = result as Error<DriverLoginResponseModel>;
      expect(errorResult.exception, isA<NetworkFailures>());
      verify(mockInternetConnection.hasInternetAccess).called(2);
      verifyNever(mockApiClient.loginDriver(tRequest.email, tRequest.password));
    });
  });
}
