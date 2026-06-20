import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/auth_module/data/models/apply_response_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/country_model.dart';
import 'package:track_flowers_app/features/auth_module/data/models/vehicle_type_model.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_params.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/apply_driver_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_countries_use_case.dart';
import 'package:track_flowers_app/features/auth_module/domain/use_cases/get_vehicles_use_case.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends BaseCubit<AuthModuleState, AuthModuleEvent> {
  final GetVehiclesUseCase getVehiclesUseCase;
  final GetCountriesUseCase getCountriesUseCase;
  final ApplyDriverUseCase applyDriverUseCase;

  AuthModuleCubit(
    this.getVehiclesUseCase,
    this.getCountriesUseCase,
    this.applyDriverUseCase,
  ) : super(const AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {
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

  Future<void> _getInitialData() async {
    emit(
      state.copyWith(
        vehiclesState: const BaseState.loading(),
        countriesState: const BaseState.loading(),
      ),
    );

    final countriesResult = await getCountriesUseCase.call(const NoParams());
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

    final vehiclesResult = await getVehiclesUseCase.call(const NoParams());
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
    final result = await applyDriverUseCase.call(params);
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
