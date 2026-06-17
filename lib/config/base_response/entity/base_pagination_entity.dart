import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/uses_cases/pagination_params.dart';

class BasePaginationEntity<T> {
  final MetaEntity meta;
  final List<T> data;

  BasePaginationEntity({required this.meta, required this.data});

  static BasePaginationEntity<E> dummyData<E>({
    required PaginationParams params,
    required List<E> allData,
  }) {
    final page = params.page ?? 1;
    final limit = params.limit ?? 20;

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    final paginatedData = allData.sublist(
      startIndex.clamp(0, allData.length),
      endIndex.clamp(0, allData.length),
    );

    return BasePaginationEntity(
      meta: MetaEntity(
        total: allData.length,
        limit: limit,
        currentPage: page,
        numberOfPages: (allData.length / limit).ceil(),
      ),
      data: paginatedData,
    );
  }
}
