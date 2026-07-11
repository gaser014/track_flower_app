import 'package:mockito/annotations.dart';
import 'package:track_flowers_app/features/auth_module/domain/repositories/auth_module_repository.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_remote_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_local_data_source_contract.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/main_profile/domain/repositories/profile_repository.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/reset_password_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/get_profile_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/update_profile_photo_use_case.dart';

@GenerateMocks([
  AuthModuleRepository,
  AuthModuleRemoteDataSourceContract,
  AuthModuleLocalDataSourceContract,
  AuthModuleApiClient,
  ProfileRepository,
  ResetPasswordUseCase,
  GetProfileUseCase,
  EditProfileUseCase,
  UpdateProfilePhotoUseCase,
])
void main() {}
