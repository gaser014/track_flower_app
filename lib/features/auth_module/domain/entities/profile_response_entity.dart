import 'package:track_flowers_app/features/auth_module/domain/entities/profile_entity.dart';

class ProfileResponseEntity {
  final String? message;
  final ProfileEntity? profile;

  ProfileResponseEntity({this.message, this.profile});
}
