import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/login_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/logout_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_saved_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_token_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/delete_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

import '../auth_module_cubit_test.mocks.dart' hide MockLogoutDriverUseCase, MockGetSavedCredentialsUseCase;
import 'auth_module_cubit_test.mocks.dart' hide MockLoginDriverUseCase, MockSaveDriverTokenUseCase, MockSaveDriverCredentialsUseCase, MockDeleteDriverCredentialsUseCase;

@GenerateMocks([
  SendForgetPasswordCodeUseCase,
  VerifyForgetPasswordCodeUseCase,
  ResetPasswordUseCase,
  LoginDriverUseCase,
  LogoutDriverUseCase,
  GetSavedCredentialsUseCase,
  SaveDriverTokenUseCase,
  SaveDriverCredentialsUseCase,
  DeleteDriverCredentialsUseCase,
])
void main() {
  provideDummy<Result<void>>(const Success<void>());

  late AuthModuleCubit cubit;
  late MockSendForgetPasswordCodeUseCase mockSendForgetPasswordCodeUseCase;
  late MockVerifyForgetPasswordCodeUseCase mockVerifyForgetPasswordCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockLoginDriverUseCase mockLoginDriverUseCase;
  late MockLogoutDriverUseCase mockLogoutDriverUseCase;
  late MockGetSavedCredentialsUseCase mockGetSavedCredentialsUseCase;
  late MockSaveDriverTokenUseCase mockSaveDriverTokenUseCase;
  late MockSaveDriverCredentialsUseCase mockSaveDriverCredentialsUseCase;
  late MockDeleteDriverCredentialsUseCase mockDeleteDriverCredentialsUseCase;

  setUp(() {
    mockSendForgetPasswordCodeUseCase = MockSendForgetPasswordCodeUseCase();
    mockVerifyForgetPasswordCodeUseCase = MockVerifyForgetPasswordCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockLoginDriverUseCase = MockLoginDriverUseCase();
    mockLogoutDriverUseCase = MockLogoutDriverUseCase();
    mockGetSavedCredentialsUseCase = MockGetSavedCredentialsUseCase();
    mockSaveDriverTokenUseCase = MockSaveDriverTokenUseCase();
    mockSaveDriverCredentialsUseCase = MockSaveDriverCredentialsUseCase();
    mockDeleteDriverCredentialsUseCase = MockDeleteDriverCredentialsUseCase();
    cubit = AuthModuleCubit(
      mockSendForgetPasswordCodeUseCase,
      mockVerifyForgetPasswordCodeUseCase,
      mockResetPasswordUseCase,
      mockLoginDriverUseCase,
      mockLogoutDriverUseCase,
      mockGetSavedCredentialsUseCase,
      mockSaveDriverTokenUseCase,
      mockSaveDriverCredentialsUseCase,
      mockDeleteDriverCredentialsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthModuleCubit - SendCodeEvent', () {
    final tParams = ForgetPasswordParams(email: 'test@test.com');

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, success] when sending the code succeeds',
      build: () {
        when(
          mockSendForgetPasswordCodeUseCase.call(any),
        ).thenAnswer((_) async => const Success<void>());
        return cubit;
      },
      act: (cubit) => cubit.doIndented(SendCodeEvent(params: tParams)),
      expect: () => const [
        AuthModuleState(sendCodeState: BaseState.loading()),
        AuthModuleState(sendCodeState: BaseState.success(null)),
      ],
      verify: (_) {
        verify(mockSendForgetPasswordCodeUseCase.call(tParams)).called(1);
      },
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, error] when sending the code fails',
      build: () {
        when(
          mockSendForgetPasswordCodeUseCase.call(any),
        ).thenAnswer((_) async => Error<void>(exception: Exception('error')));
        return cubit;
      },
      act: (cubit) => cubit.doIndented(SendCodeEvent(params: tParams)),
      expect: () => [
        const AuthModuleState(sendCodeState: BaseState.loading()),
        isA<AuthModuleState>().having(
          (s) => s.sendCodeState.isError,
          'sendCodeState.isError',
          true,
        ),
      ],
      verify: (_) {
        verify(mockSendForgetPasswordCodeUseCase.call(tParams)).called(1);
      },
    );
  });

  group('AuthModuleCubit - VerifyCodeEvent', () {
    final tParams = ForgetPasswordParams(resetCode: '123456');

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, success] when verifying the code succeeds',
      build: () {
        when(
          mockVerifyForgetPasswordCodeUseCase.call(any),
        ).thenAnswer((_) async => const Success<void>());
        return cubit;
      },
      act: (cubit) => cubit.doIndented(VerifyCodeEvent(params: tParams)),
      expect: () => const [
        AuthModuleState(verifyCodeState: BaseState.loading()),
        AuthModuleState(verifyCodeState: BaseState.success(null)),
      ],
      verify: (_) {
        verify(mockVerifyForgetPasswordCodeUseCase.call(tParams)).called(1);
      },
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, error] when verifying the code fails',
      build: () {
        when(
          mockVerifyForgetPasswordCodeUseCase.call(any),
        ).thenAnswer((_) async => Error<void>(exception: Exception('error')));
        return cubit;
      },
      act: (cubit) => cubit.doIndented(VerifyCodeEvent(params: tParams)),
      expect: () => [
        const AuthModuleState(verifyCodeState: BaseState.loading()),
        isA<AuthModuleState>().having(
          (s) => s.verifyCodeState.isError,
          'verifyCodeState.isError',
          true,
        ),
      ],
      verify: (_) {
        verify(mockVerifyForgetPasswordCodeUseCase.call(tParams)).called(1);
      },
    );
  });

  group('AuthModuleCubit - ResetPasswordEvent', () {
    final tParams = ForgetPasswordParams(
      email: 'test@test.com',
      newPassword: 'newPassword123',
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, success] when resetting the password succeeds',
      build: () {
        when(
          mockResetPasswordUseCase.call(any),
        ).thenAnswer((_) async => const Success<void>());
        return cubit;
      },
      act: (cubit) => cubit.doIndented(ResetPasswordEvent(params: tParams)),
      expect: () => const [
        AuthModuleState(resetPasswordState: BaseState.loading()),
        AuthModuleState(resetPasswordState: BaseState.success(null)),
      ],
      verify: (_) {
        verify(mockResetPasswordUseCase.call(tParams)).called(1);
      },
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'emits [loading, error] when resetting the password fails',
      build: () {
        when(
          mockResetPasswordUseCase.call(any),
        ).thenAnswer((_) async => Error<void>(exception: Exception('error')));
        return cubit;
      },
      act: (cubit) => cubit.doIndented(ResetPasswordEvent(params: tParams)),
      expect: () => [
        const AuthModuleState(resetPasswordState: BaseState.loading()),
        isA<AuthModuleState>().having(
          (s) => s.resetPasswordState.isError,
          'resetPasswordState.isError',
          true,
        ),
      ],
      verify: (_) {
        verify(mockResetPasswordUseCase.call(tParams)).called(1);
      },
    );
  });
}
