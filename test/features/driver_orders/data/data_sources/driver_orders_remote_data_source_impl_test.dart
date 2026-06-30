import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/driver_orders/api/api_client/driver_orders_api_client.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/order_model.dart';
import 'package:track_flowers_app/features/driver_orders/data/models/orders_page_model.dart';
import 'package:track_flowers_app/features/driver_orders/api/data_sources/driver_orders_remote_data_source_impl.dart';

import '../../helpers/order_test_data.dart';
import 'driver_orders_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([DriverOrdersApiClient])
void main() {
  late DriverOrdersRemoteDataSourceImpl dataSource;
  late MockDriverOrdersApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockDriverOrdersApiClient();
    dataSource = DriverOrdersRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  const tParams = PaginationParams(page: 1, limit: 20);

  group('getPendingOrders', () {
    test('wraps api response in Success and forwards a sort filter', () async {
      final page = buildOrdersPageModel([buildOrderModel(state: 'pending')]);
      when(
        mockApiClient.getPendingOrders(any),
      ).thenAnswer((_) async => page);

      final result = await dataSource.getPendingOrders(tParams);

      expect(result, isA<Success<OrdersPageModel>>());
      expect((result as Success<OrdersPageModel>).data, page);

      final captured =
          verify(mockApiClient.getPendingOrders(captureAny)).captured.single
              as PaginationParams;
      expect(captured.page, 1);
      expect(captured.limit, 20);
      // pending orders must request createdAt sorting
      expect(captured.toJson()['sort'], 'createdAt');
    });

    test('returns Error when api client throws a DioException', () async {
      when(mockApiClient.getPendingOrders(any)).thenThrow(
        DioException(requestOptions: RequestOptions(path: '/pending')),
      );

      final result = await dataSource.getPendingOrders(tParams);

      expect(result, isA<Error<OrdersPageModel>>());
    });
  });

  group('getMyOrders', () {
    test('wraps api response in Success and forwards params as-is', () async {
      final page = buildOrdersPageModel([buildOrderModel(state: 'completed')]);
      when(mockApiClient.getMyOrders(any)).thenAnswer((_) async => page);

      final result = await dataSource.getMyOrders(tParams);

      expect(result, isA<Success<OrdersPageModel>>());
      final captured =
          verify(mockApiClient.getMyOrders(captureAny)).captured.single
              as PaginationParams;
      expect(captured.toJson().containsKey('sort'), isFalse);
    });
  });

  group('startOrder', () {
    test('forwards order id and wraps response in Success', () async {
      final model = buildOrderModel(state: 'picked');
      when(mockApiClient.startOrder(any)).thenAnswer((_) async => model);

      final result = await dataSource.startOrder('order-1');

      expect(result, isA<Success<OrderModel>>());
      expect((result as Success<OrderModel>).data, model);
      verify(mockApiClient.startOrder('order-1')).called(1);
    });
  });

  group('updateOrderState', () {
    test('sends the state inside the request body', () async {
      final model = buildOrderModel(state: 'completed');
      when(
        mockApiClient.updateOrderState(any, any),
      ).thenAnswer((_) async => model);

      final result = await dataSource.updateOrderState('order-1', 'completed');

      expect(result, isA<Success<OrderModel>>());
      verify(
        mockApiClient.updateOrderState('order-1', {'state': 'completed'}),
      ).called(1);
    });
  });
}
