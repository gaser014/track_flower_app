import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/database/secure_storage_helper.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/api/datasources/auth_module_local_data_source_impl.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/save_credentials_request_entity.dart';

import 'auth_module_local_data_source_impl_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late AuthModuleLocalDataSourceImpl dataSource;
  late MockFlutterSecureStorage mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    AppSecureStorage.flutterSecureStorage = mockSecureStorage;
    dataSource = AuthModuleLocalDataSourceImpl();
  });

  group('saveDriverToken', () {
    const tToken = 'test_token';

    test('should call write on secure storage with correct key and value', () async {
      // arrange
      when(mockSecureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => Future.value());

      // act
      await dataSource.saveDriverToken(tToken);

      // assert
      verify(mockSecureStorage.write(key: AppStrings.driverToken, value: tToken)).called(1);
    });
  });

  group('deleteDriverToken', () {
    test('should call delete on secure storage with correct key', () async {
      // arrange
      when(mockSecureStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => Future.value());

      // act
      await dataSource.deleteDriverToken();

      // assert
      verify(mockSecureStorage.delete(key: AppStrings.driverToken)).called(1);
    });
  });

  group('saveCredentials', () {
    const tRequest = SaveCredentialsRequestEntity(email: 'test@test.com', password: 'password');

    test('should call write on secure storage for email and password', () async {
      // arrange
      when(mockSecureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async => Future.value());

      // act
      await dataSource.saveCredentials(tRequest);

      // assert
      verify(mockSecureStorage.write(key: AppStrings.driverSavedEmail, value: tRequest.email)).called(1);
      verify(mockSecureStorage.write(key: AppStrings.driverSavedPassword, value: tRequest.password)).called(1);
    });
  });

  group('deleteCredentials', () {
    test('should call delete on secure storage for email and password', () async {
      // arrange
      when(mockSecureStorage.delete(key: anyNamed('key')))
          .thenAnswer((_) async => Future.value());

      // act
      await dataSource.deleteCredentials();

      // assert
      verify(mockSecureStorage.delete(key: AppStrings.driverSavedEmail)).called(1);
      verify(mockSecureStorage.delete(key: AppStrings.driverSavedPassword)).called(1);
    });
  });

  group('getSavedCredentials', () {
    test('should return map with saved email and password', () async {
      // arrange
      when(mockSecureStorage.read(key: AppStrings.driverSavedEmail))
          .thenAnswer((_) async => 'test@test.com');
      when(mockSecureStorage.read(key: AppStrings.driverSavedPassword))
          .thenAnswer((_) async => 'password');

      // act
      final result = await dataSource.getSavedCredentials();

      // assert
      expect(result, equals({
        AppStrings.driverSavedEmail: 'test@test.com',
        AppStrings.driverSavedPassword: 'password',
      }));
      verify(mockSecureStorage.read(key: AppStrings.driverSavedEmail)).called(1);
      verify(mockSecureStorage.read(key: AppStrings.driverSavedPassword)).called(1);
    });
  });
}
