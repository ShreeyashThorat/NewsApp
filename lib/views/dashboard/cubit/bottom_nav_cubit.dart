import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'nav_bar_items.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavState(NavbarItem.home, 0));
  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.home:
        emit(const BottomNavState(NavbarItem.home, 0));
        break;
      case NavbarItem.detailed:
        emit(const BottomNavState(NavbarItem.detailed, 1));
        break;
      case NavbarItem.bookmarked:
        emit(const BottomNavState(NavbarItem.bookmarked, 2));
        break;
      case NavbarItem.profile:
        emit(const BottomNavState(NavbarItem.profile, 3));
        break;
    }
  }
}
