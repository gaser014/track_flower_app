import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_flowers_app/config/base_state/base_state.dart';
import 'package:track_flowers_app/config/uses_cases/use_cases.dart';
import 'package:track_flowers_app/features/login/domain/entities/user_entity.dart';
import 'package:track_flowers_app/features/login/domain/use_cases/save_user_use_case.dart';
import 'package:track_flowers_app/features/main_profile/domain/use_cases/get_main_profile_use_case.dart';
import 'package:track_flowers_app/features/main_profile/presentation/view_model/cubit/main_profile_events.dart';
import 'package:injectable/injectable.dart';

part 'main_profile_states.dart';

@Injectable()
class MainProfileCubit extends Cubit<MainProfileStates> {
  MainProfileCubit(this._getMainProfileUseCase, this._saveUserUseCase)
    : super(const MainProfileStates());

  final GetMainProfileUseCase _getMainProfileUseCase;
  final SaveUserUseCase _saveUserUseCase;

  void doIndented(MainProfileEvents event) {
    switch (event) {
      case GetMainProfileEvent():
        _fetchProfile();
    }
  }

  Future<void> _fetchProfile() async {
    emit(state.copyWith(profileState: const BaseState.loading()));

    final remoteResult = await _getMainProfileUseCase.call(NoParams());
    remoteResult.when(
      success: (user) async {
        if (user != null) {
          await _saveUserUseCase.call(user);
          emit(state.copyWith(profileState: BaseState.success(user)));
        }
      },
      error: (exception) {
        emit(state.copyWith(profileState: BaseState.error(exception)));
      },
    );
  }
}
