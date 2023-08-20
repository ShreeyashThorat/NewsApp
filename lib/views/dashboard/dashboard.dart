import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/views/bookmarked/bookmarked.dart';
import 'package:news_app/views/home/home.dart';
import 'package:news_app/views/news/news.dart';

import 'cubit/bottom_nav_cubit.dart';
import 'cubit/nav_bar_items.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          if (state.navbarItem == NavbarItem.home) {
            return const HomeScreen();
          } else if (state.navbarItem == NavbarItem.detailed) {
            return const NewsScreen();
          } else if (state.navbarItem == NavbarItem.bookmarked) {
            return const BookMarkedScreen();
          } else if (state.navbarItem == NavbarItem.profile) {
            return const Center(
              child: Text("Profile"),
            );
          }
          return Container();
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavCubit, BottomNavState>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme:
                const IconThemeData(size: 23, color: Colors.white),
            unselectedIconTheme:
                IconThemeData(size: 20, color: Colors.grey.shade500),
            elevation: 0,
            backgroundColor: Colors.black,
            currentIndex: state.index,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.house,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.solidNewspaper,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.solidBookmark),
                label: 'BookMarked',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(
                  FontAwesomeIcons.solidUser,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<BottomNavCubit>(context)
                    .getNavBarItem(NavbarItem.home);
              } else if (index == 1) {
                BlocProvider.of<BottomNavCubit>(context)
                    .getNavBarItem(NavbarItem.detailed);
              } else if (index == 2) {
                BlocProvider.of<BottomNavCubit>(context)
                    .getNavBarItem(NavbarItem.bookmarked);
              } else if (index == 3) {
                BlocProvider.of<BottomNavCubit>(context)
                    .getNavBarItem(NavbarItem.profile);
              }
            },
          );
        },
      ),
    );
  }
}
