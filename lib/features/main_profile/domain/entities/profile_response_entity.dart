import 'package:track_flowers_app/features/main_profile/domain/entities/profile_entity.dart';

class ProfileResponseEntity {
  final String? message;
  final ProfileEntity? profile;

  ProfileResponseEntity({this.message, this.profile});
}
