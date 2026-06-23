import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/reset_password_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_states.dart';

import '../../../../../helpers/test_helper.mocks.dart';

void main() {
  late AuthModuleCubit cubit;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUpdateProfilePhotoUseCase mockUpdateProfilePhotoUseCase;
  late MockResetPasswordUseCase mockResetPasswordUseCase;

  setUpAll(() {
    provideDummy<Result<ResetPasswordResponseEntity>>(const Success<ResetPasswordResponseEntity>());
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUpdateProfilePhotoUseCase = MockUpdateProfilePhotoUseCase();
    mockResetPasswordUseCase = MockResetPasswordUseCase();

    cubit = AuthModuleCubit(
      mockGetProfileUseCase,
      mockEditProfileUseCase,
      mockUpdateProfilePhotoUseCase,
      mockResetPasswordUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('resetPassword', () {
    final tBody = {
      "oldPassword": "password123",
      "newPassword": "newPassword123"
    };
    final tResponseEntity = ResetPasswordResponseEntity(message: "Success");
    final tException = Exception('Failed');

    blocTest<AuthModuleCubit, AuthModuleStates>(
      'emits [loading, success] when ResetPasswordEvent is added and succeeds',
      build: () {
        when(mockResetPasswordUseCase.call(any))
            .thenAnswer((_) async => Success(data: tResponseEntity));
        return cubit;
      },
      act: (cubit) => cubit.doIndented(ResetPasswordEvent(body: tBody)),
      expect: () => [
        AuthModuleStates(resetPasswordState: const BaseState.loading()),
        AuthModuleStates(resetPasswordState: BaseState.success(tResponseEntity)),
      ],
      verify: (_) {
        verify(mockResetPasswordUseCase.call(tBody));
      },
    );

    blocTest<AuthModuleCubit, AuthModuleStates>(
      'emits [loading, error] when ResetPasswordEvent is added and fails',
      build: () {
        when(mockResetPasswordUseCase.call(any))
            .thenAnswer((_) async => Error(exception: tException));
        return cubit;
      },
      act: (cubit) => cubit.doIndented(ResetPasswordEvent(body: tBody)),
      expect: () => [
        AuthModuleStates(resetPasswordState: const BaseState.loading()),
        AuthModuleStates(resetPasswordState: BaseState.error(tException)),
      ],
      verify: (_) {
        verify(mockResetPasswordUseCase.call(tBody));
      },
    );
  });
}
