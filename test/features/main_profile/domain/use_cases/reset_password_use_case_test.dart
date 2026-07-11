import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/main_profile/domain/entities/reset_password_response_entity.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/reset_password_use_case.dart';

import '../../../../helpers/test_helper.mocks.dart';

void main() {
  late ResetPasswordUseCase useCase;
  late MockProfileRepository mockRepository;

  setUpAll(() {
    provideDummy<Result<ResetPasswordResponseEntity>>(
      const Success<ResetPasswordResponseEntity>(),
    );
  });

  setUp(() {
    mockRepository = MockProfileRepository();
    useCase = ResetPasswordUseCase(mockRepository);
  });

  final tBody = {"oldPassword": "password123", "newPassword": "newPassword123"};
  final tResponseEntity = ResetPasswordResponseEntity(message: "Success");

  test('should forward the call to the repository', () async {
    // arrange
    when(
      mockRepository.resetPassword(any),
    ).thenAnswer((_) async => Success(data: tResponseEntity));

    // act
    final result = await useCase(tBody);

    // assert
    expect(result, isA<Success<ResetPasswordResponseEntity>>());
    verify(mockRepository.resetPassword(tBody));
    verifyNoMoreInteractions(mockRepository);
  });
}
