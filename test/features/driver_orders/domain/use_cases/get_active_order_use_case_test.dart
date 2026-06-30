import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_active_order_use_case.dart';

import '../../helpers/order_test_data.dart';
import 'get_active_order_use_case_test.mocks.dart';

@GenerateMocks([DriverOrdersRepository])
void main() {
  provideDummy<Result<OrderEntity>>(const Success<OrderEntity>());

  late GetActiveOrderUseCase useCase;
  late MockDriverOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockDriverOrdersRepository();
    useCase = GetActiveOrderUseCase(mockRepository);
  });

  final tOrder = buildOrder(status: OrderStatus.accepted);

  test('should return active order from repository', () async {
    when(
      mockRepository.getActiveOrder(),
    ).thenAnswer((_) async => Success(data: tOrder));

    final result = await useCase(const NoParams());

    expect(result, isA<Success<OrderEntity>>());
    final success = result as Success<OrderEntity>;
    expect(success.data, tOrder);
    verify(mockRepository.getActiveOrder()).called(1);
  });

  test('should return success with null when no active order', () async {
    when(
      mockRepository.getActiveOrder(),
    ).thenAnswer((_) async => const Success<OrderEntity>(data: null));

    final result = await useCase(const NoParams());

    expect(result, isA<Success<OrderEntity>>());
    expect((result as Success<OrderEntity>).data, isNull);
    verify(mockRepository.getActiveOrder()).called(1);
  });

  test('should return error when repository fails', () async {
    final tException = Exception('Failed to load active order');
    when(
      mockRepository.getActiveOrder(),
    ).thenAnswer((_) async => Error(exception: tException));

    final result = await useCase(const NoParams());

    expect(result, isA<Error<OrderEntity>>());
    expect((result as Error<OrderEntity>).exception, tException);
    verify(mockRepository.getActiveOrder()).called(1);
  });
}
