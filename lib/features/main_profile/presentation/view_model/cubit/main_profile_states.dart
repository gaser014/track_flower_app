part of 'main_profile_cubit.dart';

class MainProfileStates extends Equatable {
  final BaseState<UserEntity> profileState;

  const MainProfileStates({this.profileState = const BaseState.initial()});

  MainProfileStates copyWith({BaseState<UserEntity>? profileState}) {
    return MainProfileStates(profileState: profileState ?? this.profileState);
  }

  @override
  List<Object?> get props => [profileState];
}
