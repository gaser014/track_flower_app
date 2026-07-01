import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/save_user_use_case.dart';
import 'package:track_flowers_app/features/profile/data/models/change_password_request_model.dart';
import 'package:track_flowers_app/features/profile/data/models/edit_profile_request_model.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/get_profile_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/logout_use_case.dart';
import 'package:track_flowers_app/features/profile/domain/use_cases/upload_profile_photo_use_case.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_cubit.dart';
import 'package:track_flowers_app/features/profile/presentation/view_model/cubit/profile_events.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([
  GetProfileUseCase,
  SaveUserUseCase,
  EditProfileUseCase,
  UploadProfilePhotoUseCase,
  LogoutUseCase,
  ChangePasswordUseCase,
])
void main() {
  late ProfileCubit profileCubit;
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockSaveUserUseCase mockSaveUserUseCase;
  late MockEditProfileUseCase mockEditProfileUseCase;
  late MockUploadProfilePhotoUseCase mockUploadProfilePhotoUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockChangePasswordUseCase mockChangePasswordUseCase;

  setUpAll(() {
    provideDummy<Result<UserEntity>>(Success(data: UserEntity()));
    provideDummy<Result<void>>(const Success(data: null));
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockSaveUserUseCase = MockSaveUserUseCase();
    mockEditProfileUseCase = MockEditProfileUseCase();
    mockUploadProfilePhotoUseCase = MockUploadProfilePhotoUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockChangePasswordUseCase = MockChangePasswordUseCase();

    profileCubit = ProfileCubit(
      mockGetProfileUseCase,
      mockSaveUserUseCase,
      mockEditProfileUseCase,
      mockUploadProfilePhotoUseCase,
      mockLogoutUseCase,
      mockChangePasswordUseCase,
    );
  });

  tearDown(() {
    profileCubit.close();
  });

  final tUserEntity = UserEntity(
    id: '1',
    firstName: 'Test',
    lastName: 'User',
    email: 'test@example.com',
    gender: 'Male',
    photo: 'test_photo_url',
  );

  group('ProfileCubit', () {
    test('initial state should be ProfileStates()', () {
      expect(profileCubit.state, const ProfileStates());
    });

    blocTest<ProfileCubit, ProfileStates>(
      'emits [loading, success] when GetProfileEvent is added and succeeds',
      build: () {
        when(mockGetProfileUseCase.call(const NoParams()))
            .thenAnswer((_) async => Success(data: tUserEntity));
        when(mockSaveUserUseCase.call(tUserEntity))
            .thenAnswer((_) async => Success(data: tUserEntity));
        return profileCubit;
      },
      act: (cubit) => cubit.doIndented(GetProfileEvent()),
      expect: () => [
        const ProfileStates(profileState: BaseState.loading()),
        ProfileStates(
          profileState: BaseState.success(tUserEntity),
          selectedGender: 'Male',
        ),
      ],
      verify: (_) {
        verify(mockGetProfileUseCase.call(const NoParams())).called(1);
        verify(mockSaveUserUseCase.call(tUserEntity)).called(1);
      },
    );

    final tException = Exception('Test Exception');

    blocTest<ProfileCubit, ProfileStates>(
      'emits [loading, error] when GetProfileEvent is added and fails',
      build: () {
        when(mockGetProfileUseCase.call(const NoParams()))
            .thenAnswer((_) async => Error(exception: tException));
        return profileCubit;
      },
      act: (cubit) => cubit.doIndented(GetProfileEvent()),
      expect: () => [
        const ProfileStates(profileState: BaseState.loading()),
        ProfileStates(profileState: BaseState.error(tException)),
      ],
    );

    final tEditRequest = EditProfileRequestModel(firstName: 'New', lastName: 'Name', gender: 'Female', email: 'test@example.com', phone: '123456');

    blocTest<ProfileCubit, ProfileStates>(
      'emits [loading, success] when EditProfileEvent is added and succeeds',
      build: () {
        when(mockEditProfileUseCase.call(tEditRequest))
            .thenAnswer((_) async => Success(data: tUserEntity));
        when(mockSaveUserUseCase.call(tUserEntity))
            .thenAnswer((_) async => Success(data: tUserEntity));
        return profileCubit;
      },
      act: (cubit) => cubit.doIndented(EditProfileEvent(tEditRequest)),
      expect: () => [
        const ProfileStates(editProfileState: BaseState.loading()),
        ProfileStates(
          editProfileState: BaseState.success(tUserEntity),
          profileState: BaseState.success(tUserEntity),
        ),
      ],
    );

    final tChangePasswordRequest = ChangePasswordRequestModel(
      currentPassword: 'old',
      newPassword: 'new',
      confirmPassword: 'new',
    );

    blocTest<ProfileCubit, ProfileStates>(
      'emits [loading, success] when ChangePasswordEvent is added and succeeds',
      build: () {
        when(mockChangePasswordUseCase.call(tChangePasswordRequest))
            .thenAnswer((_) async => const Success(data: null));
        return profileCubit;
      },
      act: (cubit) => cubit.doIndented(ChangePasswordEvent(tChangePasswordRequest)),
      expect: () => [
        const ProfileStates(changePasswordState: BaseState.loading()),
        const ProfileStates(changePasswordState: BaseState.success(null)),
      ],
    );

    blocTest<ProfileCubit, ProfileStates>(
      'emits new state with updated gender when ToggleGenderEvent is added',
      build: () => profileCubit,
      act: (cubit) => cubit.doIndented(ToggleGenderEvent('Female')),
      expect: () => [
        const ProfileStates(selectedGender: 'Female'),
      ],
    );

    blocTest<ProfileCubit, ProfileStates>(
      'emits new state with toggled password visibility when TogglePasswordVisibilityEvent is added',
      build: () => profileCubit,
      act: (cubit) => cubit.doIndented(TogglePasswordVisibilityEvent()),
      expect: () => [
        const ProfileStates(isPasswordVisible: true),
      ],
    );

    blocTest<ProfileCubit, ProfileStates>(
      'emits [loading, success] when LogoutEvent is added and succeeds',
      build: () {
        when(mockLogoutUseCase.call(const NoParams()))
            .thenAnswer((_) async => const Success(data: null));
        return profileCubit;
      },
      act: (cubit) => cubit.doIndented(LogoutEvent()),
      expect: () => [
        const ProfileStates(logoutState: BaseState.loading()),
        const ProfileStates(logoutState: BaseState.success(null)),
      ],
    );
  });
}
