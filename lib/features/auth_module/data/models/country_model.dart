import 'package:json_annotation/json_annotation.dart';

part 'country_model.g.dart';

@JsonSerializable()
class CountryModel {
  @JsonKey(name: "isoCode")
  final String? isoCode;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "phoneCode")
  final String? phoneCode;
  @JsonKey(name: "flag")
  final String? flag;
  @JsonKey(name: "currency")
  final String? currency;

  CountryModel({
    this.isoCode,
    this.name,
    this.phoneCode,
    this.flag,
    this.currency,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CountryModelToJson(this);
}
