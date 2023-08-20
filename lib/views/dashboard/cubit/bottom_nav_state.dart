part of 'bottom_nav_cubit.dart';

class BottomNavState extends Equatable {
  final NavbarItem navbarItem;
  final int index;
  const BottomNavState(this.navbarItem, this.index);

  @override
  List<Object> get props => [navbarItem, index];
}
