import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/accept_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/complete_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_active_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_my_orders_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/mirror_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/reject_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/domain/use_cases/start_order_use_case.dart';
import 'package:track_flowers_app/features/driver_orders/presentation/cubit/driver_orders_cubit.dart';

import '../../helpers/order_test_data.dart';
import 'driver_orders_cubit_test.mocks.dart';

@GenerateMocks([
  GetPendingOrdersUseCase,
  GetMyOrdersUseCase,
  GetActiveOrderUseCase,
  AcceptOrderUseCase,
  RejectOrderUseCase,
  StartOrderUseCase,
  CompleteOrderUseCase,
  MirrorOrderUseCase,
])
void main() {
  provideDummy<Result<BasePaginationEntity<OrderEntity>>>(
    const Success<BasePaginationEntity<OrderEntity>>(),
  );
  provideDummy<Result<OrderEntity>>(const Success<OrderEntity>());

  late MockGetPendingOrdersUseCase mockGetPending;
  late MockGetMyOrdersUseCase mockGetMyOrders;
  late MockGetActiveOrderUseCase mockGetActive;
  late MockAcceptOrderUseCase mockAccept;
  late MockRejectOrderUseCase mockReject;
  late MockStartOrderUseCase mockStart;
  late MockCompleteOrderUseCase mockComplete;
  late MockMirrorOrderUseCase mockMirror;
  late DriverOrdersCubit cubit;

  DriverOrdersCubit buildCubit() => DriverOrdersCubit(
    getPendingOrdersUseCase: mockGetPending,
    getMyOrdersUseCase: mockGetMyOrders,
    getActiveOrderUseCase: mockGetActive,
    acceptOrderUseCase: mockAccept,
    rejectOrderUseCase: mockReject,
    startOrderUseCase: mockStart,
    completeOrderUseCase: mockComplete,
    mirrorOrderUseCase: mockMirror,
  );

  setUp(() {
    mockGetPending = MockGetPendingOrdersUseCase();
    mockGetMyOrders = MockGetMyOrdersUseCase();
    mockGetActive = MockGetActiveOrderUseCase();
    mockAccept = MockAcceptOrderUseCase();
    mockReject = MockRejectOrderUseCase();
    mockStart = MockStartOrderUseCase();
    mockComplete = MockCompleteOrderUseCase();
    mockMirror = MockMirrorOrderUseCase();
    cubit = buildCubit();

    when(
      mockMirror.call(
        any,
        driverLat: anyNamed('driverLat'),
        driverLng: anyNamed('driverLng'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => cubit.close());

  final tPending = buildOrder(id: 'p1', status: OrderStatus.pending);

  test('initial state is all-initial', () {
    expect(cubit.state.pendingState.isInitial, true);
    expect(cubit.state.myOrdersState.isInitial, true);
    expect(cubit.state.activeState.isInitial, true);
  });

  group('GetPendingOrdersEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'emits [loading, success] when use case succeeds',
      build: () {
        when(
          mockGetPending.call(any),
        ).thenAnswer((_) async => Success(data: buildOrdersPage([tPending])));
        return cubit;
      },
      act: (c) => c.doIntent(const GetPendingOrdersEvent()),
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.pendingState.isLoading,
          'pending.loading',
          true,
        ),
        isA<DriverOrdersStates>()
            .having((s) => s.pendingState.isSuccess, 'pending.success', true)
            .having((s) => s.pendingState.data, 'pending.data', [tPending]),
      ],
      verify: (_) => verify(mockGetPending.call(any)).called(1),
    );

    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'emits [loading, error] when use case fails',
      build: () {
        when(
          mockGetPending.call(any),
        ).thenAnswer((_) async => Error(exception: Exception('boom')));
        return cubit;
      },
      act: (c) => c.doIntent(const GetPendingOrdersEvent()),
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.pendingState.isLoading,
          'pending.loading',
          true,
        ),
        isA<DriverOrdersStates>().having(
          (s) => s.pendingState.isError,
          'pending.error',
          true,
        ),
      ],
    );

    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'does not trigger a second load while already loading',
      build: () {
        when(
          mockGetPending.call(any),
        ).thenAnswer((_) async => Success(data: buildOrdersPage([tPending])));
        return cubit;
      },
      act: (c) async {
        c.doIntent(const GetPendingOrdersEvent());
        c.doIntent(const GetPendingOrdersEvent());
        await Future.delayed(const Duration(milliseconds: 50));
      },
      verify: (_) => verify(mockGetPending.call(any)).called(1),
    );
  });

  group('GetMyOrdersEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'emits [loading, success] when use case succeeds',
      build: () {
        when(mockGetMyOrders.call(any)).thenAnswer(
          (_) async => Success(
            data: buildOrdersPage([
              buildOrder(id: 'm1', status: OrderStatus.completed),
            ]),
          ),
        );
        return cubit;
      },
      act: (c) => c.doIntent(const GetMyOrdersEvent()),
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.myOrdersState.isLoading,
          'my.loading',
          true,
        ),
        isA<DriverOrdersStates>().having(
          (s) => s.myOrdersState.isSuccess,
          'my.success',
          true,
        ),
      ],
    );
  });

  group('GetActiveOrderEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'emits [loading, success] when there is an active order',
      build: () {
        when(mockGetActive.call(any)).thenAnswer(
          (_) async =>
              Success(data: buildOrder(status: OrderStatus.accepted)),
        );
        return cubit;
      },
      act: (c) => c.doIntent(const GetActiveOrderEvent()),
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.isLoading,
          'active.loading',
          true,
        ),
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.isSuccess,
          'active.success',
          true,
        ),
      ],
    );

    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'emits [loading, initial] when there is no active order',
      build: () {
        when(
          mockGetActive.call(any),
        ).thenAnswer((_) async => const Success<OrderEntity>(data: null));
        return cubit;
      },
      act: (c) => c.doIntent(const GetActiveOrderEvent()),
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.isLoading,
          'active.loading',
          true,
        ),
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.isInitial,
          'active.initial',
          true,
        ),
      ],
    );
  });

  group('AcceptOrderEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'sets the accepted order as active and mirrors it',
      build: () {
        when(mockAccept.call(any)).thenAnswer(
          (_) async =>
              Success(data: tPending.copyWith(status: OrderStatus.accepted)),
        );
        return cubit;
      },
      act: (c) => c.doIntent(AcceptOrderEvent(tPending)),
      expect: () => [
        isA<DriverOrdersStates>()
            .having((s) => s.activeState.isSuccess, 'active.success', true)
            .having(
              (s) => s.activeState.data?.status,
              'active.status',
              OrderStatus.accepted,
            ),
      ],
      verify: (_) {
        verify(mockAccept.call(tPending)).called(1);
        verify(
          mockMirror.call(
            any,
            driverLat: anyNamed('driverLat'),
            driverLng: anyNamed('driverLng'),
          ),
        ).called(1);
      },
    );
  });

  group('RejectOrderEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'calls the reject use case',
      build: () {
        when(
          mockReject.call(any),
        ).thenAnswer((_) async => Success(data: tPending));
        return cubit;
      },
      act: (c) => c.doIntent(RejectOrderEvent(tPending)),
      verify: (_) => verify(mockReject.call(tPending)).called(1),
    );
  });

  group('AdvanceOrderEvent', () {
    blocTest<DriverOrdersCubit, DriverOrdersStates>(
      'advances an accepted order to picked via startOrder use case',
      build: () {
        final accepted = buildOrder(status: OrderStatus.accepted);
        when(
          mockStart.call(any),
        ).thenAnswer((_) async => Success(data: accepted));
        return cubit;
      },
      act: (c) async {
        c.doIntent(
          SetActiveOrderEvent(buildOrder(status: OrderStatus.accepted)),
        );
        c.doIntent(const AdvanceOrderEvent());
      },
      expect: () => [
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.data?.status,
          'active.status accepted',
          OrderStatus.accepted,
        ),
        isA<DriverOrdersStates>().having(
          (s) => s.activeState.data?.status,
          'active.status picked',
          OrderStatus.picked,
        ),
      ],
      verify: (_) => verify(mockStart.call(any)).called(1),
    );
  });
}
