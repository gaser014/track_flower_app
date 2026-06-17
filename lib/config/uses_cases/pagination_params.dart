import 'filter_param.dart';
import 'params.dart';

class PaginationParams extends Params {
  final int? page;
  final int? limit;
  final List<FilterParam> filterList;

  const PaginationParams({
    this.limit = 20,
    this.page = 1,
    this.filterList = const [],
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
    };

    for (final filter in filterList) {
      filter.isActive && filter.value != null
          ? data[filter.key] = filter.value
          : null;
    }

    return data;
  }

  PaginationParams copyWith({
    int? page,
    int? limit,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      filterList: filterList ,
    );
  }

  @override
  List<Object?> get props => [limit, page, filterList];
}
