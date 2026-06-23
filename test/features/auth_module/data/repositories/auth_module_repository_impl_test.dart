import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/repositories/auth_module_repository_impl.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthModuleRepositoryImpl repository;
  late MockAuthModuleRemoteDataSourceContract mockRemoteDataSource;
  late MockAuthModuleLocalDataSourceContract mockLocalDataSource;

  setUpAll(() {
    provideDummy<Result<ResetPasswordResponseModel>>(const Success<ResetPasswordResponseModel>());
  });

  setUp(() {
    mockRemoteDataSource = MockAuthModuleRemoteDataSourceContract();
    mockLocalDataSource = MockAuthModuleLocalDataSourceContract();
    repository = AuthModuleRepositoryImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  group('resetPassword', () {
    final tBody = {
      "oldPassword": "password123",
      "newPassword": "newPassword123"
    };
    final tResponseModel = ResetPasswordResponseModel(message: "Success");

    test('should return Success with entity when remote call is successful', () async {
      // arrange
      when(mockRemoteDataSource.resetPassword(any))
          .thenAnswer((_) async => Success(data: tResponseModel));

      // act
      final result = await repository.resetPassword(tBody);

      // assert
      expect(result, isA<Success>());
      verify(mockRemoteDataSource.resetPassword(tBody));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return Error when remote call fails', () async {
      // arrange
      final tException = Exception('Failed');
      when(mockRemoteDataSource.resetPassword(any))
          .thenAnswer((_) async => Error(exception: tException));

      // act
      final result = await repository.resetPassword(tBody);

      // assert
      expect(result, isA<Error>());
      verify(mockRemoteDataSource.resetPassword(tBody));
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });
}
