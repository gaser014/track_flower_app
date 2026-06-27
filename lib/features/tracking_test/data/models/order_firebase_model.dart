import 'package:json_annotation/json_annotation.dart';
import 'package:track_flowers_app/features/tracking_test/data/models/driver_firebase_model.dart';
import '../../domain/entities/order_entity.dart';
import 'location_model.dart';

part 'order_firebase_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderFirebaseModel extends OrderEntity {
  @JsonKey(name: 'location')
  final LocationModel locationModel;

  @JsonKey(name: 'driver')
  final DriverFirebaseModel? driverModel;

  const OrderFirebaseModel({
    super.id,
    required super.status,
    required this.locationModel,
    this.driverModel,
  }) : super(location: locationModel, driver: driverModel);

  factory OrderFirebaseModel.fromJson(Map<String, dynamic> json) =>
      _$OrderFirebaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderFirebaseModelToJson(this);

  factory OrderFirebaseModel.fromEntity(OrderEntity entity) {
    final driver = entity.driver;
    return OrderFirebaseModel(
      id: entity.id,
      status: entity.status,
      locationModel: LocationModel.fromEntity(entity.location),
      driverModel: driver == null
          ? null
          : DriverFirebaseModel.fromEntity(driver),
    );
  }
}
