sealed class HomeEvents {}

class ChangeBottomNavIndexEvent extends HomeEvents {
  final int index;
  ChangeBottomNavIndexEvent(this.index);
}
