import 'package:equatable/equatable.dart';

import 'package:track_flowers_app/features/main/presentation/view_model/cubit/home_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@LazySingleton()
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void doIndented(HomeEvents event) {
    switch (event) {
      case ChangeBottomNavIndexEvent(index: final index):
        _changeBottomNavIndex(index);
    }
  }

  void _changeBottomNavIndex(int index) {
    emit(state.copyWith(bottomNavIndex: index));
  }
}
