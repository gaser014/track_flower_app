import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';
import 'location_model.dart';

part 'order_firebase_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderFirebaseModel extends OrderEntity {
  @JsonKey(name: 'location')
  final LocationModel locationModel;

  const OrderFirebaseModel({
    super.id,
    required super.status,
    required this.locationModel,
  }) : super(location: locationModel);

  factory OrderFirebaseModel.fromJson(Map<String, dynamic> json) => _$OrderFirebaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderFirebaseModelToJson(this);

  factory OrderFirebaseModel.fromEntity(OrderEntity entity) {
    return OrderFirebaseModel(
      id: entity.id,
      status: entity.status,
      locationModel: LocationModel.fromEntity(entity.location),
    );
  }
}
