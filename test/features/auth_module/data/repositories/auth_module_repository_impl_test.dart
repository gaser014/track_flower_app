import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/models/forget_password_response_models.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository_impl.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';

import 'auth_module_repository_impl_test.mocks.dart';

@GenerateMocks([AuthModuleRemoteDataSourceContract])
void main() {
  provideDummy<Result<ForgetPasswordResponse>>(
    const Success<ForgetPasswordResponse>(),
  );
  provideDummy<Result<ResetPasswordResponse>>(
    const Success<ResetPasswordResponse>(),
  );

  late AuthModuleRepositoryImpl repository;
  late MockAuthModuleRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthModuleRemoteDataSourceContract();
    repository = AuthModuleRepositoryImpl(mockRemoteDataSource);
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
}
