import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_my_orders_use_case.dart';

import '../../helpers/order_test_data.dart';
import 'get_my_orders_use_case_test.mocks.dart';

@GenerateMocks([DriverOrdersRepository])
void main() {
  provideDummy<Result<BasePaginationEntity<OrderEntity>>>(
    const Success<BasePaginationEntity<OrderEntity>>(),
  );

  late GetMyOrdersUseCase useCase;
  late MockDriverOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockDriverOrdersRepository();
    useCase = GetMyOrdersUseCase(mockRepository);
  });

  const tParams = PaginationParams(page: 1, limit: 20);
  final tPage = buildOrdersPage([buildOrder(status: OrderStatus.completed)]);

  test('should return my orders page from repository', () async {
    when(
      mockRepository.getMyOrders(any),
    ).thenAnswer((_) async => Success(data: tPage));

    final result = await useCase(tParams);

    expect(result, isA<Success<BasePaginationEntity<OrderEntity>>>());
    final success = result as Success<BasePaginationEntity<OrderEntity>>;
    expect(success.data, tPage);
    verify(mockRepository.getMyOrders(tParams)).called(1);
  });

  test('should return error when repository fails', () async {
    final tException = Exception('Failed to load my orders');
    when(
      mockRepository.getMyOrders(any),
    ).thenAnswer((_) async => Error(exception: tException));

    final result = await useCase(tParams);

    expect(result, isA<Error<BasePaginationEntity<OrderEntity>>>());
    final error = result as Error<BasePaginationEntity<OrderEntity>>;
    expect(error.exception, tException);
    verify(mockRepository.getMyOrders(tParams)).called(1);
  });
}
