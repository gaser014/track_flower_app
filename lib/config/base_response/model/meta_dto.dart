import 'package:track_flowers_app/config/base_response/entity/meta_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta_dto.g.dart';

@JsonSerializable()
class MetaDto {
  @JsonKey(name: 'currentPage')
  final int? currentPage;

  @JsonKey(name: 'numberOfPages')
  final int? numberOfPages;

  @JsonKey(name: 'limit')
  final int? limit;

  @JsonKey(name: 'total')
  final int? total;

  const MetaDto({this.currentPage, this.numberOfPages, this.limit, this.total});

  factory MetaDto.fromJson(Map<String, dynamic> json) =>
      _$MetaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDtoToJson(this);

  MetaEntity toEntity() => MetaEntity(
    currentPage: currentPage ?? 1,
    numberOfPages: numberOfPages ?? 1,
    limit: limit ?? 20,
    total: total,
  );
}
