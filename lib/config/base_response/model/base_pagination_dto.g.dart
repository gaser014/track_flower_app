// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_pagination_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasePaginationDto<T> _$BasePaginationDtoFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => BasePaginationDto<T>(
  message: json['message'] as String?,
  metadata: json['metadata'] == null
      ? null
      : MetaDto.fromJson(json['metadata'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
);

Map<String, dynamic> _$BasePaginationDtoToJson<T>(
  BasePaginationDto<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'message': instance.message,
  'metadata': instance.metadata,
  'data': instance.data?.map(toJsonT).toList(),
};
