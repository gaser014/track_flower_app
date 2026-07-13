import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';

import 'forget_password_use_cases_test.mocks.dart';

@GenerateMocks([AuthModuleRepository])
void main() {
  provideDummy<Result<void>>(const Success<void>());

  late MockAuthModuleRepository mockRepository;
  late SendForgetPasswordCodeUseCase sendForgetPasswordCodeUseCase;
  late VerifyForgetPasswordCodeUseCase verifyForgetPasswordCodeUseCase;
  late ResetPasswordUseCase resetPasswordUseCase;

  setUp(() {
    mockRepository = MockAuthModuleRepository();
    sendForgetPasswordCodeUseCase = SendForgetPasswordCodeUseCase(
      mockRepository,
    );
    verifyForgetPasswordCodeUseCase = VerifyForgetPasswordCodeUseCase(
      mockRepository,
    );
    resetPasswordUseCase = ResetPasswordUseCase(mockRepository);
  });

  group('SendForgetPasswordCodeUseCase', () {
    final tParams = ForgetPasswordParams(email: 'test@test.com');

    test('should delegate to repository and return Success', () async {
      // Arrange
      when(
        mockRepository.sendForgetPasswordCode(any),
      ).thenAnswer((_) async => const Success<void>());

      // Act
      final result = await sendForgetPasswordCodeUseCase.call(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.sendForgetPasswordCode(tParams)).called(1);
    });

    test('should return Error when repository fails', () async {
      // Arrange
      final tException = Exception('error');
      when(
        mockRepository.sendForgetPasswordCode(any),
      ).thenAnswer((_) async => Error<void>(exception: tException));

      // Act
      final result = await sendForgetPasswordCodeUseCase.call(tParams);

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error<void>).exception, tException);
      verify(mockRepository.sendForgetPasswordCode(tParams)).called(1);
    });
  });

  group('VerifyForgetPasswordCodeUseCase', () {
    final tParams = ForgetPasswordParams(resetCode: '123456');

    test('should delegate to repository and return Success', () async {
      // Arrange
      when(
        mockRepository.verifyForgetPasswordCode(any),
      ).thenAnswer((_) async => const Success<void>());

      // Act
      final result = await verifyForgetPasswordCodeUseCase.call(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.verifyForgetPasswordCode(tParams)).called(1);
    });

    test('should return Error when repository fails', () async {
      // Arrange
      final tException = Exception('error');
      when(
        mockRepository.verifyForgetPasswordCode(any),
      ).thenAnswer((_) async => Error<void>(exception: tException));

      // Act
      final result = await verifyForgetPasswordCodeUseCase.call(tParams);

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error<void>).exception, tException);
      verify(mockRepository.verifyForgetPasswordCode(tParams)).called(1);
    });
  });

  group('ResetPasswordUseCase', () {
    final tParams = ForgetPasswordParams(
      email: 'test@test.com',
      newPassword: 'newPassword123',
    );

    test('should delegate to repository and return Success', () async {
      // Arrange
      when(
        mockRepository.resetPassword(any),
      ).thenAnswer((_) async => const Success<void>());

      // Act
      final result = await resetPasswordUseCase.call(tParams);

      // Assert
      expect(result, isA<Success<void>>());
      verify(mockRepository.resetPassword(tParams)).called(1);
    });

    test('should return Error when repository fails', () async {
      // Arrange
      final tException = Exception('error');
      when(
        mockRepository.resetPassword(any),
      ).thenAnswer((_) async => Error<void>(exception: tException));

      // Act
      final result = await resetPasswordUseCase.call(tParams);

      // Assert
      expect(result, isA<Error<void>>());
      expect((result as Error<void>).exception, tException);
      verify(mockRepository.resetPassword(tParams)).called(1);
    });
  });
}
