part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<VehicleResponseModel> vehiclesState;
  final BaseState<List<CountryModel>> countriesState;
  final BaseState<ApplyResponseModel> applyDriverState;
  final CountryModel? selectedCountry;
  final VehicleTypeModel? selectedVehicle;
  final File? vehicleLicense;
  final File? nidImage;
  final String gender;

  const AuthModuleState({
    this.vehiclesState = const BaseState.initial(),
    this.countriesState = const BaseState.initial(),
    this.applyDriverState = const BaseState.initial(),
    this.selectedCountry,
    this.selectedVehicle,
    this.vehicleLicense,
    this.nidImage,
    this.gender = 'male',
  });

  AuthModuleState copyWith({
    BaseState<VehicleResponseModel>? vehiclesState,
    BaseState<List<CountryModel>>? countriesState,
    BaseState<ApplyResponseModel>? applyDriverState,
    CountryModel? selectedCountry,
    VehicleTypeModel? selectedVehicle,
    File? vehicleLicense,
    File? nidImage,
    String? gender,
  }) {
    return AuthModuleState(
      vehiclesState: vehiclesState ?? this.vehiclesState,
      countriesState: countriesState ?? this.countriesState,
      applyDriverState: applyDriverState ?? this.applyDriverState,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedVehicle: selectedVehicle ?? this.selectedVehicle,
      vehicleLicense: vehicleLicense ?? this.vehicleLicense,
      nidImage: nidImage ?? this.nidImage,
      gender: gender ?? this.gender,
    );
  }

  @override
  List<Object?> get props => [
        vehiclesState,
        countriesState,
        applyDriverState,
        selectedCountry,
        selectedVehicle,
        vehicleLicense,
        nidImage,
        gender,
      ];
}
