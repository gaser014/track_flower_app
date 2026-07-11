import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/delete_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_countries_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_saved_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_vehicles_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/login_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/logout_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_token_use_case.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

import 'auth_module_cubit_test.mocks.dart';

@GenerateMocks([
  LoginDriverUseCase,
  LogoutDriverUseCase,
  GetSavedCredentialsUseCase,
  SaveDriverTokenUseCase,
  SaveDriverCredentialsUseCase,
  DeleteDriverCredentialsUseCase,
  SendForgetPasswordCodeUseCase,
  VerifyForgetPasswordCodeUseCase,
  ResetPasswordUseCase,
  GetVehiclesUseCase,
  GetCountriesUseCase,
  ApplyDriverUseCase,
])
void main() {
  late AuthModuleCubit cubit;
  late MockLoginDriverUseCase mockLoginDriverUseCase;
  late MockLogoutDriverUseCase mockLogoutDriverUseCase;
  late MockGetSavedCredentialsUseCase mockGetSavedCredentialsUseCase;
  late MockSaveDriverTokenUseCase mockSaveDriverTokenUseCase;
  late MockSaveDriverCredentialsUseCase mockSaveDriverCredentialsUseCase;
  late MockDeleteDriverCredentialsUseCase mockDeleteDriverCredentialsUseCase;
  late MockSendForgetPasswordCodeUseCase mockSendForgetPasswordCodeUseCase;
  late MockVerifyForgetPasswordCodeUseCase mockVerifyForgetPasswordCodeUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;
  late MockGetVehiclesUseCase mockGetVehiclesUseCase;
  late MockGetCountriesUseCase mockGetCountriesUseCase;
  late MockApplyDriverUseCase mockApplyDriverUseCase;

  // ─── Test Data ────────────────────────────────────────────────────────────
  const tEmail = 'driver@test.com';
  const tPassword = 'password123';
  const tToken = 'mock_token_xyz';

  final tDriver = DriverEntity(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Mohamed',
    email: tEmail,
    phone: '01012345678',
    role: 'driver',
  );

  final tLoginResponse = DriverLoginResponseEntity(
    message: 'success',
    token: tToken,
    driver: tDriver,
  );

  final tLoginParams = DriverLoginRequestEntity(
    email: tEmail,
    password: tPassword,
    remember: false,
  );

  final tLoginParamsRemember = DriverLoginRequestEntity(
    email: tEmail,
    password: tPassword,
    remember: true,
  );

  // ─── Setup ────────────────────────────────────────────────────────────────
  setUp(() {
    mockLoginDriverUseCase = MockLoginDriverUseCase();
    mockLogoutDriverUseCase = MockLogoutDriverUseCase();
    mockGetSavedCredentialsUseCase = MockGetSavedCredentialsUseCase();
    mockSaveDriverTokenUseCase = MockSaveDriverTokenUseCase();
    mockSaveDriverCredentialsUseCase = MockSaveDriverCredentialsUseCase();
    mockDeleteDriverCredentialsUseCase = MockDeleteDriverCredentialsUseCase();
    mockSendForgetPasswordCodeUseCase = MockSendForgetPasswordCodeUseCase();
    mockVerifyForgetPasswordCodeUseCase = MockVerifyForgetPasswordCodeUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();
    mockGetVehiclesUseCase = MockGetVehiclesUseCase();
    mockGetCountriesUseCase = MockGetCountriesUseCase();
    mockApplyDriverUseCase = MockApplyDriverUseCase();
    cubit = AuthModuleCubit(
      mockLoginDriverUseCase,
      mockLogoutDriverUseCase,
      mockGetSavedCredentialsUseCase,
      mockSaveDriverTokenUseCase,
      mockSaveDriverCredentialsUseCase,
      mockDeleteDriverCredentialsUseCase,
      mockSendForgetPasswordCodeUseCase,
      mockVerifyForgetPasswordCodeUseCase,
      mockResetPasswordUseCase,
      mockGetVehiclesUseCase,
      mockGetCountriesUseCase,
      mockApplyDriverUseCase,
    );
  });

  tearDown(() => cubit.close());

  // ─── Initial State ────────────────────────────────────────────────────────
  group('initial state', () {
    test('should be AuthModuleState with all initial values', () {
      expect(cubit.state, const AuthModuleState());
      expect(cubit.state.loginState.isInitial, true);
      expect(cubit.state.rememberMeState.data, false);
      expect(cubit.state.showPasswordState.data, false);
    });
  });

  // ─── Login ────────────────────────────────────────────────────────────────
  group('LoginEvent', () {
    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, success] when login succeeds',
      build: () {
        when(
          mockLoginDriverUseCase(tLoginParams),
        ).thenAnswer((_) async => Success(data: tLoginResponse));
        when(
          mockSaveDriverTokenUseCase(tToken),
        ).thenAnswer((_) async => const Success(data: null));
        when(
          mockDeleteDriverCredentialsUseCase(const NoParams()),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParams)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.loginState.isLoading,
          'isLoading',
          true,
        ),
        isA<AuthModuleState>()
            .having((s) => s.loginState.isSuccess, 'isSuccess', true)
            .having((s) => s.loginState.data, 'data', tLoginResponse),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should save credentials when remember is true',
      build: () {
        when(
          mockLoginDriverUseCase(tLoginParamsRemember),
        ).thenAnswer((_) async => Success(data: tLoginResponse));
        when(
          mockSaveDriverTokenUseCase(tToken),
        ).thenAnswer((_) async => const Success(data: null));
        when(
          mockSaveDriverCredentialsUseCase(
            const SaveDriverCredentialsParams(
              email: tEmail,
              password: tPassword,
            ),
          ),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParamsRemember)),
      verify: (_) {
        verify(
          mockSaveDriverCredentialsUseCase(
            const SaveDriverCredentialsParams(
              email: tEmail,
              password: tPassword,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, error] when login fails',
      build: () {
        when(mockLoginDriverUseCase(tLoginParams)).thenAnswer(
          (_) async => Error(exception: Exception('Invalid credentials')),
        );
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParams)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.loginState.isLoading,
          'isLoading',
          true,
        ),
        isA<AuthModuleState>().having(
          (s) => s.loginState.isError,
          'isError',
          true,
        ),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should not save token when response token is null',
      build: () {
        when(mockLoginDriverUseCase(tLoginParams)).thenAnswer(
          (_) async => Success(
            data: DriverLoginResponseEntity(
              message: 'success',
              token: null,
              driver: tDriver,
            ),
          ),
        );
        when(
          mockDeleteDriverCredentialsUseCase(const NoParams()),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParams)),
      verify: (_) {
        verifyNever(mockSaveDriverTokenUseCase(any));
      },
    );
  });

  // ─── Logout ───────────────────────────────────────────────────────────────
  group('LogoutEvent', () {
    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, success] when logout succeeds',
      build: () {
        when(
          mockLogoutDriverUseCase(const NoParams()),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LogoutEvent()),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<AuthModuleState>().having(
          (s) => s.logoutState.isSuccess,
          'isSuccess',
          true,
        ),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, error] when logout fails',
      build: () {
        when(
          mockLogoutDriverUseCase(const NoParams()),
        ).thenAnswer((_) async => Error(exception: Exception('Storage error')));
        return cubit;
      },
      act: (c) => c.doIndented(LogoutEvent()),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.logoutState.isLoading,
          'isLoading',
          true,
        ),
        isA<AuthModuleState>().having(
          (s) => s.logoutState.isError,
          'isError',
          true,
        ),
      ],
    );
  });

  // ─── Remember Me ──────────────────────────────────────────────────────────
  group('RememberMeEvent', () {
    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit state with rememberMe = true',
      build: () => cubit,
      act: (c) => c.doIndented(RememberMeEvent(rememberMe: true)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.rememberMeState.data,
          'rememberMe',
          true,
        ),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit state with rememberMe = false',
      build: () => cubit,
      act: (c) => c.doIndented(RememberMeEvent(rememberMe: false)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.rememberMeState.data,
          'rememberMe',
          false,
        ),
      ],
    );
  });

  // ─── Show Password ────────────────────────────────────────────────────────
  group('ShowPasswordEvent', () {
    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit state with showPassword = true',
      build: () => cubit,
      act: (c) => c.doIndented(ShowPasswordEvent(showPassword: true)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.showPasswordState.data,
          'showPassword',
          true,
        ),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit state with showPassword = false',
      build: () => cubit,
      act: (c) => c.doIndented(ShowPasswordEvent(showPassword: false)),
      expect: () => [
        isA<AuthModuleState>().having(
          (s) => s.showPasswordState.data,
          'showPassword',
          false,
        ),
      ],
    );
  });

  // ─── Load Saved Credentials ───────────────────────────────────────────────
  group('loadSavedCredentials', () {
    final tCredentials = {
      'driverSavedEmail': tEmail,
      'driverSavedPassword': tPassword,
    };

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit savedCredentials and rememberMe=true when credentials exist',
      build: () {
        when(
          mockGetSavedCredentialsUseCase(const NoParams()),
        ).thenAnswer((_) async => Success(data: tCredentials));
        return cubit;
      },
      act: (c) => c.loadSavedCredentials(),
      expect: () => [
        isA<AuthModuleState>()
            .having(
              (s) => s.savedCredentials.isSuccess,
              'savedCredentials isSuccess',
              true,
            )
            .having((s) => s.rememberMeState.data, 'rememberMe', true),
      ],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should not emit when credentials are empty',
      build: () {
        when(mockGetSavedCredentialsUseCase(const NoParams())).thenAnswer(
          (_) async => Success(
            data: {'driverSavedEmail': null, 'driverSavedPassword': null},
          ),
        );
        return cubit;
      },
      act: (c) => c.loadSavedCredentials(),
      expect: () => [],
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should not emit when getSavedCredentials returns error',
      build: () {
        when(
          mockGetSavedCredentialsUseCase(const NoParams()),
        ).thenAnswer((_) async => Error(exception: Exception('Storage error')));
        return cubit;
      },
      act: (c) => c.loadSavedCredentials(),
      expect: () => [],
    );
  });
}
