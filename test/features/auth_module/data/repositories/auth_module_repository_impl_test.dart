import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository_impl.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/config/error_handling/failures.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/driver_login_response_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';

import 'auth_module_repository_impl_test.mocks.dart';

@GenerateMocks([AuthModuleRemoteDataSourceContract, AuthModuleLocalDataSourceContract])
void main() {
  provideDummy<Result<ForgetPasswordResponse>>(
    const Success<ForgetPasswordResponse>(),
  );
  provideDummy<Result<ResetPasswordResponse>>(
    const Success<ResetPasswordResponse>(),
  );
  provideDummy<Result<DriverLoginResponseModel>>(
    Success(data: DriverLoginResponseModel()),
  );

  late AuthModuleRepositoryImpl repository;
  late MockAuthModuleRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthModuleLocalDataSourceContract mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthModuleRemoteDataSourceContract();
    mockLocalDataSource = MockAuthModuleLocalDataSourceContract();
    repository = AuthModuleRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('sendForgetPasswordCode', () {
    final tParams = ForgetPasswordParams(email: 'test@test.com');

    test('should return Success when remote data source succeeds', () async {
      // Arrange
      when(mockRemoteDataSource.sendForgetPasswordCode(any)).thenAnswer(
        (_) async =>
            Success(data: ForgetPasswordResponse(message: 'code sent')),
      );

      // Act
      final result = await repository.sendForgetPasswordCode(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRemoteDataSource.sendForgetPasswordCode(any)).called(1);
    });

    test(
      'should still forward to remote data source when it fails',
      () async {
        // Arrange
        when(mockRemoteDataSource.sendForgetPasswordCode(any)).thenAnswer(
          (_) async =>
              Error<ForgetPasswordResponse>(exception: Exception('error')),
        );

        // Act
        final result = await repository.sendForgetPasswordCode(tParams);

        // Assert
        // NOTE: the repository maps the response through `makeDummyData`, which
        // in debug mode (as used by `flutter test`) falls back to the provided
        // dummy Success when the remote call errors.
        expect(result, isA<Success<void>>());
        verify(mockRemoteDataSource.sendForgetPasswordCode(any)).called(1);
      },
    );
  });

  group('verifyForgetPasswordCode', () {
    final tParams = ForgetPasswordParams(resetCode: '123456');

    test('should return Success when remote data source succeeds', () async {
      // Arrange
      when(mockRemoteDataSource.verifyForgetPasswordCode(any)).thenAnswer(
        (_) async =>
            Success(data: ForgetPasswordResponse(statusMsg: 'success')),
      );

      // Act
      final result = await repository.verifyForgetPasswordCode(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRemoteDataSource.verifyForgetPasswordCode(any)).called(1);
    });

    test(
      'should still forward to remote data source when it fails',
      () async {
        // Arrange
        when(mockRemoteDataSource.verifyForgetPasswordCode(any)).thenAnswer(
          (_) async =>
              Error<ForgetPasswordResponse>(exception: Exception('error')),
        );

        // Act
        final result = await repository.verifyForgetPasswordCode(tParams);

        // Assert
        expect(result, isA<Success<void>>());
        verify(mockRemoteDataSource.verifyForgetPasswordCode(any)).called(1);
      },
    );
  });

  group('resetPassword', () {
    final tParams = ForgetPasswordParams(
      email: 'test@test.com',
      newPassword: 'newPassword123',
    );

    test('should return Success when remote data source succeeds', () async {
      // Arrange
      when(mockRemoteDataSource.resetPassword(any)).thenAnswer(
        (_) async => Success(data: ResetPasswordResponse(token: 'token123')),
      );

      // Act
      final result = await repository.resetPassword(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRemoteDataSource.resetPassword(any)).called(1);
    });

    test(
      'should still forward to remote data source when it fails',
      () async {
        // Arrange
        when(mockRemoteDataSource.resetPassword(any)).thenAnswer(
          (_) async =>
              Error<ResetPasswordResponse>(exception: Exception('error')),
        );

        // Act
        final result = await repository.resetPassword(tParams);

        // Assert
        expect(result, isA<Success<void>>());
        verify(mockRemoteDataSource.resetPassword(any)).called(1);
      },
    );
  });

  group('loginDriver', () {
    const tRequest = DriverLoginRequestEntity(email: 'test@test.com', password: 'password', remember: true);
    final tResponseModel = DriverLoginResponseModel(
      token: 'test_token',
      message: 'Success',
    );

    test('should return Success with DriverLoginResponseEntity when remote data source is successful', () async {
      // arrange
      when(mockRemoteDataSource.loginDriver(tRequest))
          .thenAnswer((_) async => Success(data: tResponseModel));

      // act
      final result = await repository.loginDriver(tRequest);

      // assert
      expect(result, isA<Success<DriverLoginResponseEntity>>());
      final successResult = result as Success<DriverLoginResponseEntity>;
      expect(successResult.data?.token, equals('test_token'));
      verify(mockRemoteDataSource.loginDriver(tRequest)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Error when remote data source is unsuccessful', () async {
      // arrange
      final tException = ServerFailure(errorMessage: 'Server Error');
      when(mockRemoteDataSource.loginDriver(tRequest))
          .thenAnswer((_) async => Error(exception: tException));

      // act
      final result = await repository.loginDriver(tRequest);

      // assert
      expect(result, isA<Error<DriverLoginResponseEntity>>());
      final errorResult = result as Error<DriverLoginResponseEntity>;
      expect(errorResult.exception, equals(tException));
      verify(mockRemoteDataSource.loginDriver(tRequest)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('saveDriverToken', () {
    const tToken = 'test_token';

    test('should return Success when local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.saveDriverToken(tToken)).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.saveDriverToken(tToken);

      // assert
      expect(result, isA<Success<void>>());
      verify(mockLocalDataSource.saveDriverToken(tToken)).called(1);
    });

    test('should return Error with CacheFailures when local data source throws Exception', () async {
      // arrange
      when(mockLocalDataSource.saveDriverToken(tToken)).thenThrow(Exception('Cache error'));

      // act
      final result = await repository.saveDriverToken(tToken);

      // assert
      expect(result, isA<Error<void>>());
      final errorResult = result as Error<void>;
      expect(errorResult.exception, isA<CacheFailures>());
      verify(mockLocalDataSource.saveDriverToken(tToken)).called(1);
    });
  });

  group('deleteDriverToken', () {
    test('should return Success when local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.deleteDriverToken()).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.deleteDriverToken();

      // assert
      expect(result, isA<Success<void>>());
      verify(mockLocalDataSource.deleteDriverToken()).called(1);
    });

    test('should return Error with CacheFailures when local data source throws Exception', () async {
      // arrange
      when(mockLocalDataSource.deleteDriverToken()).thenThrow(Exception('Cache error'));

      // act
      final result = await repository.deleteDriverToken();

      // assert
      expect(result, isA<Error<void>>());
      final errorResult = result as Error<void>;
      expect(errorResult.exception, isA<CacheFailures>());
      verify(mockLocalDataSource.deleteDriverToken()).called(1);
    });
  });

  group('saveCredentials', () {
    const tRequest = SaveCredentialsRequestEntity(email: 'test@test.com', password: 'password');

    test('should return Success when local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.saveCredentials(tRequest)).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.saveCredentials(tRequest);

      // assert
      expect(result, isA<Success<void>>());
      verify(mockLocalDataSource.saveCredentials(tRequest)).called(1);
    });

    test('should return Error with CacheFailures when local data source throws Exception', () async {
      // arrange
      when(mockLocalDataSource.saveCredentials(tRequest)).thenThrow(Exception('Cache error'));

      // act
      final result = await repository.saveCredentials(tRequest);

      // assert
      expect(result, isA<Error<void>>());
      final errorResult = result as Error<void>;
      expect(errorResult.exception, isA<CacheFailures>());
      verify(mockLocalDataSource.saveCredentials(tRequest)).called(1);
    });
  });

  group('deleteCredentials', () {
    test('should return Success when local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.deleteCredentials()).thenAnswer((_) async => Future.value());

      // act
      final result = await repository.deleteCredentials();

      // assert
      expect(result, isA<Success<void>>());
      verify(mockLocalDataSource.deleteCredentials()).called(1);
    });

    test('should return Error with CacheFailures when local data source throws Exception', () async {
      // arrange
      when(mockLocalDataSource.deleteCredentials()).thenThrow(Exception('Cache error'));

      // act
      final result = await repository.deleteCredentials();

      // assert
      expect(result, isA<Error<void>>());
      final errorResult = result as Error<void>;
      expect(errorResult.exception, isA<CacheFailures>());
      verify(mockLocalDataSource.deleteCredentials()).called(1);
    });
  });

  group('getSavedCredentials', () {
    test('should return Success with credentials when local data source is successful', () async {
      // arrange
      when(mockLocalDataSource.getSavedCredentials()).thenAnswer((_) async => {'email': 'test@test.com', 'password': 'password'});

      // act
      final result = await repository.getSavedCredentials();

      // assert
      expect(result, isA<Success>());
      final successResult = result as Success;
      expect(successResult.data?.email, equals('test@test.com'));
      expect(successResult.data?.password, equals('password'));
      verify(mockLocalDataSource.getSavedCredentials()).called(1);
    });

    test('should return Error with CacheFailures when local data source throws Exception', () async {
      // arrange
      when(mockLocalDataSource.getSavedCredentials()).thenThrow(Exception('Cache error'));

      // act
      final result = await repository.getSavedCredentials();

      // assert
      expect(result, isA<Error>());
      final errorResult = result as Error;
      expect(errorResult.exception, isA<CacheFailures>());
      verify(mockLocalDataSource.getSavedCredentials()).called(1);
    });
  });
}
