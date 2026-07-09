import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/firebase/order_tracking_service.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/driver_orders/data/data_sources/driver_orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/driver_orders/data/fixtures/driver_orders_fixtures.dart';
import 'package:track_flowers_app/features/driver_orders/data/mapper/order_firestore_mapper.dart';
import 'package:track_flowers_app/features/driver_orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/driver_orders/domain/repositories/driver_orders_repository.dart';
import 'package:track_flowers_app/features/tracking_test/data/models/driver_firebase_model.dart';
import 'package:track_flowers_app/features/tracking_test/domain/entities/driver_entity.dart';
import 'package:track_flowers_app/features/tracking_test/domain/repositories/tracking_repository.dart';

@LazySingleton(as: DriverOrdersRepository)
class DriverOrdersRepositoryImpl implements DriverOrdersRepository {
  final DriverOrdersRemoteDataSourceContract _remoteDataSource;
  final TrackingRepository _trackingRepository;
  final OrderTrackingService _orderTrackingService;

  DriverOrdersRepositoryImpl({
    required DriverOrdersRemoteDataSourceContract remoteDataSource,
    required TrackingRepository trackingRepository,
    required OrderTrackingService orderTrackingService,
  }) : _remoteDataSource = remoteDataSource,
       _trackingRepository = trackingRepository,
       _orderTrackingService = orderTrackingService;

  @override
  Future<Result<BasePaginationEntity<OrderEntity>>> getPendingOrders(
    PaginationParams params,
  ) async {
    final result = await _remoteDataSource.getPendingOrders(params);
    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData(
        params: params,
        allData: DriverOrdersFixtures.pendingOrders,
      ),
      success: (data) => Success(
        data: BasePaginationEntity(
          meta: data?.meta ?? const MetaEntity.empty(),
          data: data?.orders.map((e) => e.toEntity()).toList() ?? const [],
        ),
      ),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<BasePaginationEntity<OrderEntity>>> getMyOrders(
    PaginationParams params,
  ) async {
    final result = await _remoteDataSource.getMyOrders(params);
    return result.makeDummyData(
      dummyData: BasePaginationEntity.dummyData(
        params: params,
        allData: DriverOrdersFixtures.myOrders,
      ),
      success: (data) {
        final orders =
            data?.orders.map((e) => e.toEntity()).toList() ?? <OrderEntity>[];
        orders.sort(
          (a, b) => a.status.ui.sortIndex.compareTo(b.status.ui.sortIndex),
        );
        return Success(
          data: BasePaginationEntity(
            meta: data?.meta ?? const MetaEntity.empty(),
            data: orders,
          ),
        );
      },
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<OrderEntity>> getActiveOrder() async {
    final result = await _remoteDataSource.getMyOrders(
      const PaginationParams(page: 1, limit: 50),
    );
    return result.makeDummyData<OrderEntity>(
      success: (data) {
        final orders = data?.orders ?? const [];
        OrderEntity? active;
        for (final model in orders) {
          final entity = model.toEntity();
          if (entity.status.isActive) {
            active = entity;
            break;
          }
        }
        return Success<OrderEntity>(data: active);
      },
      error: (_) => const Success<OrderEntity>(data: null),
    );
  }

  @override
  Future<Result<OrderEntity>> acceptOrder(OrderEntity order) async {
    final result = await _remoteDataSource.startOrder(order.id);
    final status = order.status.next;
    log(
      'acceptOrder: ${order.id} status: $status',
      name: 'DriverOrdersRepository',
    );
    return result.makeDummyData(
      dummyData: order.copyWith(status: order.status.next),
      success: (data) =>
          Success(data: order.copyWith(status: order.status.next)),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<Result<OrderEntity>> rejectOrder(OrderEntity order) async =>
      Success(data: order);

  @override
  Future<Result<OrderEntity>> startOrder(OrderEntity order) async =>
      Success(data: order.copyWith(status: OrderStatus.accepted));

  @override
  Future<Result<OrderEntity>> completeOrder(OrderEntity order) async {
    final result = await _remoteDataSource.updateOrderState(
      order.id,
      'completed',
    );
    return result.makeDummyData(
      dummyData: order.copyWith(status: OrderStatus.completed),
      success: (data) => Success(data: data?.toEntity()),
      error: (exception) => Error(exception: exception),
    );
  }

  @override
  Future<void> mirrorOrderToFirebase(
    OrderEntity order, {
    double? driverLat,
    double? driverLng,
  }) async {
    if (order.id.isEmpty) return;
    try {
      final driver = DriverFirebaseModel.fromEntity(DriverEntity());

      final firestoreMap = order.toFirestoreMap(
        driverId: driver.id,
        driverName: driver.name,
        driverPhone: driver.phone,
        driverPhoto: driver.photo,
        driverLat: driverLat,
        driverLng: driverLng,
      );

      await _trackingRepository.upsertOrder(order.id, firestoreMap);

      // Mirror the order onto the customer's user document and notify them
      // of the latest status change.
      if (order.userId.isNotEmpty) {
        await _orderTrackingService.setUserOrder(
          userId: order.userId,
          orderId: order.id,
          data: firestoreMap,
        );
        await _orderTrackingService.notifyUser(
          userId: order.userId,
          title: AppStrings.orderNotificationTitle,
          body: order.status.notificationBody,
        );
      }
    } catch (e, s) {
      log(
        'mirrorOrderToFirebase failed',
        name: 'DriverOrdersRepository',
        error: e,
        stackTrace: s,
      );
    }
  }

  // /// Cached driver profile (saved at login).
  // Future<UserModel?> _currentDriver() async {
  //   try {
  //     return await _loginLocalDataSource.getUser();
  //   } catch (_) {
  //     return null;
  //   }
  // }

  // Future<String?> _currentDriverId() async {
  //   final token = await _authLocalDataSource.getUserToken();
  //   if (token == null || token.isEmpty) return null;
  //   for (final key in const ['id', 'userId', '_id', 'sub']) {
  //     final value = JwtUtils.getClaim<dynamic>(token, key);
  //     if (value != null && value.toString().isNotEmpty) {
  //       return value.toString();
  //     }
  //   }
  //   return null;
  // }
}
