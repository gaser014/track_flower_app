part of 'auth_module_cubit.dart';

class AuthModuleState extends Equatable {
  final BaseState<dynamic> loginState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<dynamic> logoutState;
  final BaseState<Map<String, String?>> savedCredentials;
  final BaseState<void> sendCodeState;
  final BaseState<void> verifyCodeState;
  final BaseState<void> resetPasswordState;
  final BaseState<DriverLoginResponseEntity> loginState;
  final BaseState<void> logoutState;
  final BaseState<bool> rememberMeState;
  final BaseState<bool> showPasswordState;
  final BaseState<Map<String, String?>> savedCredentials;
  final BaseState<VehicleResponseModel> vehiclesState;
  final BaseState<List<CountryModel>> countriesState;
  final BaseState<ApplyResponseModel> applyDriverState;
  final CountryModel? selectedCountry;
  final VehicleTypeModel? selectedVehicle;
  final File? vehicleLicense;
  final File? nidImage;
  final String gender;

  const AuthModuleState({
    this.loginState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.logoutState = const BaseState.initial(),
    this.savedCredentials = const BaseState.initial(),
    this.sendCodeState = const BaseState.initial(),
    this.verifyCodeState = const BaseState.initial(),
    this.resetPasswordState = const BaseState.initial(),
    this.loginState = const BaseState.initial(),
    this.logoutState = const BaseState.initial(),
    this.rememberMeState = const BaseState.success(false),
    this.showPasswordState = const BaseState.success(false),
    this.savedCredentials = const BaseState.initial(),
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
    BaseState<dynamic>? loginState,
    BaseState<bool>? rememberMeState,
    BaseState<void>? sendCodeState,
    BaseState<void>? verifyCodeState,
    BaseState<void>? resetPasswordState,
    BaseState<DriverLoginResponseEntity>? loginState,
    BaseState<void>? logoutState,
    BaseState<bool>? rememberMeState,
    BaseState<bool>? showPasswordState,
    BaseState<Map<String, String?>>? savedCredentials,

    BaseState<bool>? showPasswordState,
    BaseState<dynamic>? logoutState,
    BaseState<Map<String, String?>>? savedCredentials,
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
      loginState: loginState ?? this.loginState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      logoutState: logoutState ?? this.logoutState,
      savedCredentials: savedCredentials ?? this.savedCredentials,
      sendCodeState: sendCodeState ?? this.sendCodeState,
      verifyCodeState: verifyCodeState ?? this.verifyCodeState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      loginState: loginState ?? this.loginState,
      logoutState: logoutState ?? this.logoutState,
      rememberMeState: rememberMeState ?? this.rememberMeState,
      showPasswordState: showPasswordState ?? this.showPasswordState,
      savedCredentials: savedCredentials ?? this.savedCredentials,
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
        loginState,
        rememberMeState,
        showPasswordState,
        logoutState,
        savedCredentials,
    sendCodeState,    loginState,
    logoutState,
    rememberMeState,
    showPasswordState,
    savedCredentials,

    verifyCodeState,
    resetPasswordState,
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
