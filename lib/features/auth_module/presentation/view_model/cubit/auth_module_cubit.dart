import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_request_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/driver_login_response_entity.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/delete_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_countries_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_saved_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_vehicles_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/login_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/logout_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_credentials_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/save_driver_token_use_case.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';
import 'package:track_flowers_app/config/base_state/base_event.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/core/values/app_strings.dart';
import 'package:track_flowers_app/features/auth_module/domain/entities/forget_password_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/forget_password_use_cases.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends BaseCubit<AuthModuleState, BaseEvent> {
  final LoginDriverUseCase _loginDriverUseCase;
  final LogoutDriverUseCase _logoutDriverUseCase;
  final GetSavedCredentialsUseCase _getSavedCredentialsUseCase;
  final SaveDriverTokenUseCase _saveDriverTokenUseCase;
  final SaveDriverCredentialsUseCase _saveDriverCredentialsUseCase;
  final DeleteDriverCredentialsUseCase _deleteDriverCredentialsUseCase;
  final SendForgetPasswordCodeUseCase _sendForgetPasswordCodeUseCase;
  final VerifyForgetPasswordCodeUseCase _verifyForgetPasswordCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final GetVehiclesUseCase _getVehiclesUseCase;
  final GetCountriesUseCase _getCountriesUseCase;
  final ApplyDriverUseCase _applyDriverUseCase;

  AuthModuleCubit(
    this._loginDriverUseCase,
    this._logoutDriverUseCase,
    this._getSavedCredentialsUseCase,
    this._saveDriverTokenUseCase,
    this._saveDriverCredentialsUseCase,
    this._deleteDriverCredentialsUseCase,
    this._sendForgetPasswordCodeUseCase,
    this._verifyForgetPasswordCodeUseCase,
    this._resetPasswordUseCase,
    this._getVehiclesUseCase,
    this._getCountriesUseCase,
    this._applyDriverUseCase,
  ) : super(AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {
      case LoginEvent():
        _login(event.params);
      case RememberMeEvent():
        _rememberMe(event.rememberMe);
      case ShowPasswordEvent():
        _showPassword(event.showPassword);
      case LogoutEvent():
        _logout();
      case SendCodeEvent():
        _sendCode(event.params);
      case VerifyCodeEvent():
        _verifyCode(event.params);
      case ResetPasswordEvent():
        _resetPassword(event.params);

      case GetInitialDataEvent():
        _getInitialData();
      case ApplyDriverEvent():
        _applyDriver(event.params);
      case ChangeCountryEvent():
        emit(state.copyWith(selectedCountry: event.country));
      case ChangeVehicleEvent():
        emit(state.copyWith(selectedVehicle: event.vehicle));
      case PickVehicleLicenseEvent():
        emit(state.copyWith(vehicleLicense: event.file));
      case PickNidImageEvent():
        emit(state.copyWith(nidImage: event.file));
      case ChangeGenderEvent():
        emit(state.copyWith(gender: event.gender));
    }
  }

  Future<void> loadSavedCredentials() async {
    final result = await _getSavedCredentialsUseCase(const NoParams());
    result.when(
      success: (credentials) {
        if (credentials != null &&
            credentials['driverSavedEmail'] != null &&
            credentials['driverSavedPassword'] != null) {
          emit(
            state.copyWith(
              savedCredentials: BaseState.success(credentials),
              rememberMeState: const BaseState.success(true),
            ),
          );
        }
      },
      error: (_) {},
    );
  }

  Future<void> _login(DriverLoginRequestEntity params) async {
    emit(state.copyWith(loginState: BaseState.loading()));
    final result = await _loginDriverUseCase(params);
    result.when(
      success: (response) async {
        if (response?.token != null) {
          await _saveDriverTokenUseCase(response!.token!);
        }
        if (params.remember ?? false) {
          await _saveDriverCredentialsUseCase(
            SaveDriverCredentialsParams(
              email: params.email,
              password: params.password,
            ),
          );
        } else {
          await _deleteDriverCredentialsUseCase(const NoParams());
        }
        emit(state.copyWith(loginState: BaseState.success(response)));
      },
      error: (exception) {
        emit(state.copyWith(loginState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _rememberMe(bool rememberMe) async {
    emit(state.copyWith(rememberMeState: BaseState.success(rememberMe)));
  }

  Future<void> _showPassword(bool showPassword) async {
    emit(state.copyWith(showPasswordState: BaseState.success(showPassword)));
  }

  Future<void> _logout() async {
    emit(state.copyWith(logoutState: BaseState.loading()));
    final result = await _logoutDriverUseCase(const NoParams());
    result.when(
      success: (_) {
        emit(state.copyWith(logoutState: BaseState.success(null)));
      },
      error: (exception) {
        emit(state.copyWith(logoutState: BaseState.error(exception)));
      },
    );
  }

  Future<void> _sendCode(ForgetPasswordParams params) async {
    emit(state.copyWith(sendCodeState: const BaseState.loading()));
    final result = await _sendForgetPasswordCodeUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(sendCodeState: const BaseState.success(null)));
        emitEvent(PageChangeEvent(1));
      },
      error: (exception) {
        emit(state.copyWith(sendCodeState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }

  Future<void> _verifyCode(ForgetPasswordParams params) async {
    emit(state.copyWith(verifyCodeState: const BaseState.loading()));
    final result = await _verifyForgetPasswordCodeUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(verifyCodeState: const BaseState.success(null)));
        emitEvent(PageChangeEvent(2));
      },
      error: (exception) {
        emit(state.copyWith(verifyCodeState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }

  Future<void> _resetPassword(ForgetPasswordParams params) async {
    emit(state.copyWith(resetPasswordState: const BaseState.loading()));
    final result = await _resetPasswordUseCase.call(params);
    result.when(
      success: (_) {
        emit(state.copyWith(resetPasswordState: const BaseState.success(null)));
        emitEvent(DisplaySuccess(AppStrings.passwordResetSuccess));
        emitEvent(PopEvent());
      },
      error: (exception) {
        emit(state.copyWith(resetPasswordState: BaseState.error(exception)));
        emitEvent(DisplayError(exception.toString()));
      },
    );
  }
  // logout

  //apply

  Future<void> _getInitialData() async {
    emit(
      state.copyWith(
        vehiclesState: const BaseState.loading(),
        countriesState: const BaseState.loading(),
      ),
    );

    final countriesResult = await _getCountriesUseCase.call(const NoParams());
    countriesResult.when(
      success: (data) {
        emit(
          state.copyWith(
            countriesState: BaseState.success(data),
            selectedCountry: data?.isNotEmpty == true
                ? data!.firstWhere(
                    (c) => c.name == 'Egypt',
                    orElse: () => data.first,
                  )
                : null,
          ),
        );
      },
      error: (error) {
        emit(state.copyWith(countriesState: BaseState.error(error)));
      },
    );

    final vehiclesResult = await _getVehiclesUseCase.call(const NoParams());
    vehiclesResult.when(
      success: (data) {
        emit(
          state.copyWith(
            vehiclesState: BaseState.success(data),
            selectedVehicle: data?.vehicles?.isNotEmpty == true
                ? data!.vehicles!.first
                : null,
          ),
        );
      },
      error: (error) {
        emit(state.copyWith(vehiclesState: BaseState.error(error)));
      },
    );
  }

  Future<void> _applyDriver(ApplyDriverParams params) async {
    emit(state.copyWith(applyDriverState: const BaseState.loading()));
    final result = await _applyDriverUseCase.call(params);
    result.when(
      success: (data) {
        emit(state.copyWith(applyDriverState: BaseState.success(data)));
      },
      error: (error) {
        emit(state.copyWith(applyDriverState: BaseState.error(error)));
      },
    );
  }
}
