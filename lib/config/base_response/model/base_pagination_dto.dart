import 'package:track_flowers_app/config/base_response/entity/base_pagination_entity.dart';
import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:track_flowers_app/config/base_response/model/meta_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_pagination_dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BasePaginationDto<T> {
  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'metadata')
  final MetaDto? metadata;

  @JsonKey(name: 'data')
  final List<T>? data;

  const BasePaginationDto({this.message, this.metadata, this.data});

  factory BasePaginationDto.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BasePaginationDtoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BasePaginationDtoToJson(this, toJsonT);

  BasePaginationEntity<E> mapToEntity<E>(E Function(T) mapper) {
    final meta = metadata?.toEntity() ?? const MetaEntity.empty();
    final items = data?.map(mapper).toList() ?? <E>[];

    return BasePaginationEntity<E>(meta: meta, data: items);
  }

  BasePaginationEntity toEntity() {
    throw UnimplementedError('toEntity() must be overridden in subclasses');
  }
}
