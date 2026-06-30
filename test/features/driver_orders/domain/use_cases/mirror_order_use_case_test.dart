import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/mirror_order_use_case.dart';

import '../../helpers/order_test_data.dart';
import 'mirror_order_use_case_test.mocks.dart';

@GenerateMocks([DriverOrdersRepository])
void main() {
  late MirrorOrderUseCase useCase;
  late MockDriverOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockDriverOrdersRepository();
    useCase = MirrorOrderUseCase(mockRepository);
  });

  final tOrder = buildOrder(status: OrderStatus.accepted);

  test('should forward order to repository.mirrorOrderToFirebase', () async {
    when(
      mockRepository.mirrorOrderToFirebase(
        any,
        driverLat: anyNamed('driverLat'),
        driverLng: anyNamed('driverLng'),
      ),
    ).thenAnswer((_) async {});

    await useCase(tOrder);

    verify(
      mockRepository.mirrorOrderToFirebase(
        tOrder,
        driverLat: null,
        driverLng: null,
      ),
    ).called(1);
  });

  test('should forward driver coordinates when provided', () async {
    when(
      mockRepository.mirrorOrderToFirebase(
        any,
        driverLat: anyNamed('driverLat'),
        driverLng: anyNamed('driverLng'),
      ),
    ).thenAnswer((_) async {});

    await useCase(tOrder, driverLat: 30.1, driverLng: 31.2);

    verify(
      mockRepository.mirrorOrderToFirebase(
        tOrder,
        driverLat: 30.1,
        driverLng: 31.2,
      ),
    ).called(1);
  });
}
