import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/start_order_use_case.dart';

import '../../helpers/order_test_data.dart';
import 'start_order_use_case_test.mocks.dart';

@GenerateMocks([DriverOrdersRepository])
void main() {
  provideDummy<Result<OrderEntity>>(const Success<OrderEntity>());

  late StartOrderUseCase useCase;
  late MockDriverOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockDriverOrdersRepository();
    useCase = StartOrderUseCase(mockRepository);
  });

  final tOrder = buildOrder(status: OrderStatus.accepted);
  final tStarted = tOrder.copyWith(status: OrderStatus.picked);

  test('should start order via repository', () async {
    when(
      mockRepository.startOrder(any),
    ).thenAnswer((_) async => Success(data: tStarted));

    final result = await useCase(tOrder);

    expect(result, isA<Success<OrderEntity>>());
    expect((result as Success<OrderEntity>).data, tStarted);
    verify(mockRepository.startOrder(tOrder)).called(1);
  });

  test('should return error when repository fails', () async {
    final tException = Exception('Start failed');
    when(
      mockRepository.startOrder(any),
    ).thenAnswer((_) async => Error(exception: tException));

    final result = await useCase(tOrder);

    expect(result, isA<Error<OrderEntity>>());
    expect((result as Error<OrderEntity>).exception, tException);
    verify(mockRepository.startOrder(tOrder)).called(1);
  });
}
