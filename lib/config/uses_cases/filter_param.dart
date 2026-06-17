import 'package:equatable/equatable.dart';

class FilterParam extends Equatable {
  final String key;
  final dynamic value;
  final bool isActive;

  const FilterParam({
    required this.key,
    required this.value,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [key, value];
}
