import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/api/api_execute.dart';
import 'package:track_flowers_app/config/base_response/result.dart';
import 'package:track_flowers_app/core/constants/app_constants.dart';
import 'package:track_flowers_app/features/auth_module/data/datasources/auth_module_datasource.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';

abstract class AuthModuleRepository {
  Future<Result<VehicleResponseModel>> getVehicles();
  Future<Result<ApplyResponseModel>> applyDriver({
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
  Future<Result<List<CountryModel>>> getCountries();
}

@Injectable(as: AuthModuleRepository)
class AuthModuleRepositoryImpl implements AuthModuleRepository {
  final AuthModuleDatasource _datasource;

  AuthModuleRepositoryImpl(this._datasource);

  @override
  Future<Result<VehicleResponseModel>> getVehicles() {
    return executeApi(() => _datasource.getVehicles());
  }

  @override
  Future<Result<ApplyResponseModel>> applyDriver({
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
    return executeApi(
      () => _datasource.applyDriver(
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
      ),
    );
  }

  @override
  Future<Result<List<CountryModel>>> getCountries() async {
    try {
      final String response = await rootBundle.loadString(
        AppConstants.countriesJsonPath,
      );
      final List<dynamic> data = json.decode(response);
      return Success(
        data: data.map((json) => CountryModel.fromJson(json)).toList(),
      );
    } catch (e) {
      return Error(exception: Exception(e.toString()));
    }
  }
}
