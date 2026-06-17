part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int bottomNavIndex;

  const HomeState({this.bottomNavIndex = 0});

  HomeState copyWith({int? bottomNavIndex}) {
    return HomeState(bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex);
  }

  @override
  List<Object?> get props => [bottomNavIndex];
}
