import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/login_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

import 'auth_module_cubit_test.mocks.dart';

@GenerateMocks([AuthModuleRepository])
void main() {
  late AuthModuleCubit cubit;
  late MockAuthModuleRepository mockRepository;

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

  final tLoginParams = LoginParams(
    email: tEmail,
    password: tPassword,
    remember: false,
  );

  final tLoginParamsRemember = LoginParams(
    email: tEmail,
    password: tPassword,
    remember: true,
  );

  // ─── Setup ────────────────────────────────────────────────────────────────
  setUp(() {
    mockRepository = MockAuthModuleRepository();
    cubit = AuthModuleCubit(mockRepository);
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
          mockRepository.loginDriver(tLoginParams),
        ).thenAnswer((_) async => Success(data: tLoginResponse));
        when(
          mockRepository.saveDriverToken(tToken),
        ).thenAnswer((_) async => const Success(data: null));
        when(
          mockRepository.deleteCredentials(),
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
          mockRepository.loginDriver(tLoginParamsRemember),
        ).thenAnswer((_) async => Success(data: tLoginResponse));
        when(
          mockRepository.saveDriverToken(tToken),
        ).thenAnswer((_) async => const Success(data: null));
        when(
          mockRepository.saveCredentials(email: tEmail, password: tPassword),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParamsRemember)),
      verify: (_) {
        verify(
          mockRepository.saveCredentials(email: tEmail, password: tPassword),
        ).called(1);
      },
    );

    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, error] when login fails',
      build: () {
        when(mockRepository.loginDriver(tLoginParams)).thenAnswer(
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
        when(mockRepository.loginDriver(tLoginParams)).thenAnswer(
          (_) async => Success(
            data: DriverLoginResponseEntity(
              message: 'success',
              token: null,
              driver: tDriver,
            ),
          ),
        );
        when(
          mockRepository.deleteCredentials(),
        ).thenAnswer((_) async => const Success(data: null));
        return cubit;
      },
      act: (c) => c.doIndented(LoginEvent(params: tLoginParams)),
      verify: (_) {
        verifyNever(mockRepository.saveDriverToken(any));
      },
    );
  });

  // ─── Logout ───────────────────────────────────────────────────────────────
  group('LogoutEvent', () {
    blocTest<AuthModuleCubit, AuthModuleState>(
      'should emit [loading, success] when logout succeeds',
      build: () {
        when(
          mockRepository.deleteDriverToken(),
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
          mockRepository.deleteDriverToken(),
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
          mockRepository.getSavedCredentials(),
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
        when(mockRepository.getSavedCredentials()).thenAnswer(
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
          mockRepository.getSavedCredentials(),
        ).thenAnswer((_) async => Error(exception: Exception('Storage error')));
        return cubit;
      },
      act: (c) => c.loadSavedCredentials(),
      expect: () => [],
    );
  });
}
