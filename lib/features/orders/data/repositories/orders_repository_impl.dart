import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';
import 'package:track_flowers_app/features/orders/data/datasources/orders_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/orders/data/mapper/orders_mapper.dart';
import 'package:track_flowers_app/features/orders/domain/entities/order_entity.dart';
import 'package:track_flowers_app/features/orders/domain/repositories/orders_repository.dart';

@Injectable(as: OrdersRepositoryContract)
class OrdersRepositoryImpl implements OrdersRepositoryContract {
  final OrdersRemoteDataSourceContract _remoteDataSource;

  const OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<OrdersPageEntity>> getOrders(PaginationParams params) async {
    final result = await _remoteDataSource.getOrders(params);
    return result.when(
      success: (data) => Success<OrdersPageEntity>(
        data:
            data?.toEntity() ??
            const OrdersPageEntity(orders: [], meta: MetaEntity.empty()),
      ),
      error: (exception) => Error<OrdersPageEntity>(exception: exception),
    );
  }
}
