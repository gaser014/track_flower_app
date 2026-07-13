import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';
import 'location_model.dart';

part 'user_firebase_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserFirebaseModel extends UserEntity {
  @JsonKey(name: 'location')
  final LocationModel locationModel;

  const UserFirebaseModel({
    required super.userId,
    required super.fcmToken,
    required this.locationModel,
    required super.language,
  }) : super(location: locationModel);

  factory UserFirebaseModel.fromJson(Map<String, dynamic> json) => _$UserFirebaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserFirebaseModelToJson(this);

  factory UserFirebaseModel.fromEntity(UserEntity entity) {
    return UserFirebaseModel(
      userId: entity.userId,
      fcmToken: entity.fcmToken,
      locationModel: LocationModel.fromEntity(entity.location),
      language: entity.language,
    );
  }
}
