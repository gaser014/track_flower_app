import 'dart:io';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';

sealed class AuthModuleEvent {}

class GetInitialDataEvent extends AuthModuleEvent {}

class ApplyDriverEvent extends AuthModuleEvent {
  final ApplyDriverParams params;

  ApplyDriverEvent(this.params);
}

class ChangeCountryEvent extends AuthModuleEvent {
  final CountryModel country;
  ChangeCountryEvent(this.country);
}

class ChangeVehicleEvent extends AuthModuleEvent {
  final VehicleTypeModel vehicle;
  ChangeVehicleEvent(this.vehicle);
}

class PickVehicleLicenseEvent extends AuthModuleEvent {
  final File file;
  PickVehicleLicenseEvent(this.file);
}

class PickNidImageEvent extends AuthModuleEvent {
  final File file;
  PickNidImageEvent(this.file);
}

class ChangeGenderEvent extends AuthModuleEvent {
  final String gender;
  ChangeGenderEvent(this.gender);
}

