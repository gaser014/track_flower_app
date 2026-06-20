import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/features/auth_module/api/api_client/auth_module_api_client.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';

abstract class AuthModuleDatasource {
  Future<VehicleResponseModel> getVehicles();
  Future<ApplyResponseModel> applyDriver({
    required String country,
    required String firstName,
    required String lastName,
    required String vehicleType,
    required String vehicleNumber,
    required File vehicleLicense,
    required String nid,
    required File nidImg,
    required String email,
    required String password,
    required String rePassword,
    required String gender,
    required String phone,
  });
}

@Injectable(as: AuthModuleDatasource)
class AuthModuleDatasourceImpl implements AuthModuleDatasource {
  final AuthModuleApiClient _apiClient;

  AuthModuleDatasourceImpl(this._apiClient);

  @override
  Future<VehicleResponseModel> getVehicles() {
    return _apiClient.getVehicles();
  }

  @override
  Future<ApplyResponseModel> applyDriver({
    required String country,
    required String firstName,
    required String lastName,
    required String vehicleType,
    required String vehicleNumber,
    required File vehicleLicense,
    required String nid,
    required File nidImg,
    required String email,
    required String password,
    required String rePassword,
    required String gender,
    required String phone,
  }) {
    return _apiClient.applyDriver(
      country: country,
      firstName: firstName,
      lastName: lastName,
      vehicleType: vehicleType,
      vehicleNumber: vehicleNumber,
      vehicleLicense: vehicleLicense,
      nid: nid,
      nidImg: nidImg,
      email: email,
      password: password,
      rePassword: rePassword,
      gender: gender,
      phone: phone,
    );
  }
}
