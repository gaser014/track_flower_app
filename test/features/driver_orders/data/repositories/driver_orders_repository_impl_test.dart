import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/firebase/order_tracking_service.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/repositories/driver_orders_repository_impl.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/tracking_test/domain/repositories/tracking_repository.dart';

import '../../helpers/order_test_data.dart';
import 'driver_orders_repository_impl_test.mocks.dart';

@GenerateMocks([
  DriverOrdersRemoteDataSourceContract,
  TrackingRepository,
  OrderTrackingService,
])
void main() {
  provideDummy<Result<OrdersPageModel>>(const Success<OrdersPageModel>());
  provideDummy<Result<OrderModel>>(const Success<OrderModel>());

  late DriverOrdersRepositoryImpl repository;
  late MockDriverOrdersRemoteDataSourceContract mockRemote;
  late MockTrackingRepository mockTracking;
  late MockOrderTrackingService mockOrderTracking;

  setUp(() {
    mockRemote = MockDriverOrdersRemoteDataSourceContract();
    mockTracking = MockTrackingRepository();
    mockOrderTracking = MockOrderTrackingService();
    repository = DriverOrdersRepositoryImpl(
      remoteDataSource: mockRemote,
      trackingRepository: mockTracking,
      orderTrackingService: mockOrderTracking,
    );
  });

  const tParams = PaginationParams(page: 1, limit: 20);

  group('getPendingOrders', () {
    test('maps remote page model to a paginated entity on success', () async {
      final pageModel = buildOrdersPageModel([
        buildOrderModel(id: 'order-1', state: 'pending'),
      ]);
      when(
        mockRemote.getPendingOrders(any),
      ).thenAnswer((_) async => Success(data: pageModel));

      final result = await repository.getPendingOrders(tParams);

      expect(result, isA<Success>());
      final data = (result as Success).data;
      expect(data.data, hasLength(1));
      expect(data.data.first.id, 'order-1');
      verify(mockRemote.getPendingOrders(tParams)).called(1);
    });
  });

  group('getMyOrders', () {
    test('maps and sorts remote orders by status sort index', () async {
      final pageModel = buildOrdersPageModel([
        buildOrderModel(id: 'completed', state: 'completed'),
        buildOrderModel(id: 'accepted', state: 'accepted'),
      ]);
      when(
        mockRemote.getMyOrders(any),
      ).thenAnswer((_) async => Success(data: pageModel));

      final result = await repository.getMyOrders(tParams);

      expect(result, isA<Success>());
      final data = (result as Success).data;
      expect(data.data, hasLength(2));
      // accepted (sortIndex 2) should come before completed (sortIndex 6)
      expect(data.data.first.status, OrderStatus.accepted);
      expect(data.data.last.status, OrderStatus.completed);
    });
  });

  group('getActiveOrder', () {
    test('returns the first active order when one exists', () async {
      final pageModel = buildOrdersPageModel([
        buildOrderModel(id: 'pending', state: 'pending'),
        buildOrderModel(id: 'active', state: 'picked'),
      ]);
      when(
        mockRemote.getMyOrders(any),
      ).thenAnswer((_) async => Success(data: pageModel));

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data?.id, 'active');
    });

    test('returns success with null when no active order exists', () async {
      final pageModel = buildOrdersPageModel([
        buildOrderModel(id: 'pending', state: 'pending'),
        buildOrderModel(id: 'done', state: 'completed'),
      ]);
      when(
        mockRemote.getMyOrders(any),
      ).thenAnswer((_) async => Success(data: pageModel));

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data, isNull);
    });

    test('returns success with null on remote failure', () async {
      when(
        mockRemote.getMyOrders(any),
      ).thenAnswer((_) async => Error(exception: Exception('network')));

      final result = await repository.getActiveOrder();

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data, isNull);
    });
  });

  group('acceptOrder / rejectOrder', () {
    test('acceptOrder returns the order with accepted status', () async {
      final order = buildOrder(status: OrderStatus.pending);

      final result = await repository.acceptOrder(order);

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data?.status, OrderStatus.accepted);
    });

    test('rejectOrder returns the same order', () async {
      final order = buildOrder(status: OrderStatus.pending);

      final result = await repository.rejectOrder(order);

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data, order);
    });
  });

  group('startOrder', () {
    test('maps remote order model to entity on success', () async {
      when(
        mockRemote.startOrder(any),
      ).thenAnswer((_) async => Success(data: buildOrderModel(state: 'picked')));

      final result = await repository.startOrder(
        buildOrder(status: OrderStatus.accepted),
      );

      expect(result, isA<Success<OrderEntity>>());
      expect((result as Success<OrderEntity>).data?.status, OrderStatus.picked);
      verify(mockRemote.startOrder('order-1')).called(1);
    });
  });

  group('completeOrder', () {
    test('maps remote order model to entity on success', () async {
      when(mockRemote.updateOrderState(any, any)).thenAnswer(
        (_) async => Success(data: buildOrderModel(state: 'completed')),
      );

      final result = await repository.completeOrder(
        buildOrder(status: OrderStatus.delivered),
      );

      expect(result, isA<Success<OrderEntity>>());
      expect(
        (result as Success<OrderEntity>).data?.status,
        OrderStatus.completed,
      );
      verify(mockRemote.updateOrderState('order-1', 'completed')).called(1);
    });
  });

  group('mirrorOrderToFirebase', () {
    test('upserts order and mirrors it onto the user document', () async {
      when(mockTracking.upsertOrder(any, any)).thenAnswer((_) async {});
      when(
        mockOrderTracking.setUserOrder(
          userId: anyNamed('userId'),
          orderId: anyNamed('orderId'),
          data: anyNamed('data'),
        ),
      ).thenAnswer((_) async {});
      when(
        mockOrderTracking.notifyUser(
          userId: anyNamed('userId'),
          title: anyNamed('title'),
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async {});

      final order = buildOrder(status: OrderStatus.accepted);
      await repository.mirrorOrderToFirebase(order);

      verify(mockTracking.upsertOrder('order-1', any)).called(1);
      verify(
        mockOrderTracking.setUserOrder(
          userId: 'user-1',
          orderId: 'order-1',
          data: anyNamed('data'),
        ),
      ).called(1);
    });

    test('does nothing when order id is empty', () async {
      final order = buildOrder(id: '', status: OrderStatus.accepted);

      await repository.mirrorOrderToFirebase(order);

      verifyNever(mockTracking.upsertOrder(any, any));
    });
  });
}
