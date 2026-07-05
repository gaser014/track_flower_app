import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:track_flowers_app/config/base_state/base_cubit.dart';
import 'package:track_flowers_app/features/auth_module/presentation/view_model/cubit/auth_module_events.dart';

part 'auth_module_states.dart';

@injectable
class AuthModuleCubit extends BaseCubit<AuthModuleState, AuthModuleEvent> {
  AuthModuleCubit() : super(const AuthModuleState());

  void doIndented(AuthModuleEvent event) {
    switch (event) {}
  }
}
