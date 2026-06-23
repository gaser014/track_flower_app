import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/api/datasources/auth_module_remote_data_source_impl.dart';
import 'package:track_flowers_app/features/auth_module/data/models/reset_password_response_model.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthModuleRemoteDataSourceImpl remoteDataSource;
  late MockAuthModuleApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockAuthModuleApiClient();
    remoteDataSource = AuthModuleRemoteDataSourceImpl(mockApiClient);
  });

  group('resetPassword', () {
    final tBody = {
      "oldPassword": "password123",
      "newPassword": "newPassword123"
    };
    final tResponseModel = ResetPasswordResponseModel(message: "Success");

    test('should return Success containing ResetPasswordResponseModel when api call is successful', () async {
      // arrange
      when(mockApiClient.resetPassword(any))
          .thenAnswer((_) async => tResponseModel);

      // act
      final result = await remoteDataSource.resetPassword(tBody);

      // assert
      expect(result, isA<Success>());
      verify(mockApiClient.resetPassword(tBody));
      verifyNoMoreInteractions(mockApiClient);
    });

    test('should return Error when api call throws exception', () async {
      // arrange
      when(mockApiClient.resetPassword(any))
          .thenThrow(Exception('Failed'));

      // act
      final result = await remoteDataSource.resetPassword(tBody);

      // assert
      expect(result, isA<Error>());
      verify(mockApiClient.resetPassword(tBody));
      verifyNoMoreInteractions(mockApiClient);
    });
  });
}
