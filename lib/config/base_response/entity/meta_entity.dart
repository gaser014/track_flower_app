import 'package:equatable/equatable.dart';

class MetaEntity extends Equatable {
  final int currentPage;
  final int numberOfPages;
  final int limit;
  final int? total;

  const MetaEntity({
    required this.currentPage,
    required this.numberOfPages,
    required this.limit,
    this.total,
  });

  const MetaEntity.empty()
      : currentPage = 1,
        numberOfPages = 1,
        limit = 20,
        total = 0;

  bool get hasNextPage => currentPage < numberOfPages;

  bool get hasPreviousPage => currentPage > 1;

  bool get isFirstPage => currentPage == 1;

  bool get isLastPage => currentPage >= numberOfPages;

  int get nextPage => hasNextPage ? currentPage + 1 : currentPage;

  int get previousPage => hasPreviousPage ? currentPage - 1 : currentPage;

  int get totalItems => total ?? (numberOfPages * limit);

  MetaEntity copyWith({
    int? currentPage,
    int? numberOfPages,
    int? limit,
    int? total,
  }) {
    return MetaEntity(
      currentPage: currentPage ?? this.currentPage,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      limit: limit ?? this.limit,
      total: total ?? this.total,
    );
  }

  @override
  List<Object?> get props => [currentPage, numberOfPages, limit, total];

  @override
  String toString() =>
      'MetaEntity(page: $currentPage/$numberOfPages, limit: $limit, total: $total)';
}
