import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:balagh/cubits/user_cubit/user_states.dart';
import 'package:balagh/features/users/add_report/add_report_view.dart';
import 'package:balagh/features/users/community/community_view.dart';
import 'package:balagh/features/users/home/home_view.dart';
import 'package:balagh/features/users/profile/profile_view.dart';
import 'package:balagh/features/users/ranking/ranking_view.dart';
import 'package:balagh/features/users/reports/reports_view.dart';
import 'package:balagh/features/users/widgets/navbar_item.dart';
import 'package:balagh/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNavigation extends StatefulWidget {
  const UserNavigation({super.key});

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}

class _UserNavigationState extends State<UserNavigation> {
  int _currentTab = 0;
  appUser? user;

  late PageController _pageController;

  void _openAddReport() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => const AddReportView());
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _pageController = PageController(initialPage: _currentTab);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final userAuthenticated = FirebaseAuth.instance.currentUser!;
      user = await getUserData(userAuthenticated.uid);
      setState(() {});
    } catch (error) {}
  }

  void navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getTabName(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 'Community';
      case 2:
        return 'Reports';
      case 3:
        return 'Ranking';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeView(navigateToPage: navigateToPage),
      const CommunityView(),
      const ReportsView(),
      const RankingView(),
    ];

    SizeConfig().init;
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      if (state is UserLoading || user == null) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: kDarkBlue,
            ),
          ),
        );
      }
      if (state is UserLoaded) {
        user = state.user;
      } else if (state is UserError) {
        return const Scaffold(
          body: Center(
            child: Text('Error try Again'),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentTab == 0)
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: kDarkBlue,
                        fontSize: 14,
                      ),
                    ),
                  if (_currentTab == 0)
                    Text(
                      user!.userName,
                      style: const TextStyle(
                        color: kMidtBlue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (_currentTab != 0)
                    Text(
                      _getTabName(_currentTab),
                      style: const TextStyle(
                        color: kMidtBlue,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const ProfileView()));
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: user!.imageUrl != ''
                          ? NetworkImage(user!.imageUrl)
                          : null,
                      child: user!.imageUrl == ''
                          ? const Icon(
                              Icons.account_circle_outlined,
                              color: kDeepBlue,
                              size: 30,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: PageView(
          controller: _pageController,
          children: screens,
          onPageChanged: (index) {
            setState(() {
              _currentTab = index;
            });
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _openAddReport();
          },
          shape: const CircleBorder(),
          backgroundColor: kDeepBlue,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: kWhite,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: kWhite,
            border: Border.all(color: kDarkGrey.withOpacity(0.9), width: 1),
          ),
          child: BottomAppBar(
            elevation: 0,
            color: Colors.transparent,
            height: 80,
            shape: const CircularNotchedRectangle(),
            notchMargin: 10,
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      NavbarItem(
                          index: 0,
                          icon: Icons.home_rounded,
                          label: 'Home',
                          currentTab: _currentTab,
                          onTap: navigateToPage),
                      NavbarItem(
                          index: 1,
                          icon: Icons.groups_rounded,
                          label: 'Community',
                          currentTab: _currentTab,
                          onTap: navigateToPage),
                    ],
                  ),

                  // Right Tab bar icons

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      NavbarItem(
                          index: 2,
                          icon: Icons.location_on_rounded,
                          label: 'Reports',
                          currentTab: _currentTab,
                          onTap: navigateToPage),
                      NavbarItem(
                          index: 3,
                          icon: Icons.emoji_events_rounded,
                          label: 'Ranking',
                          currentTab: _currentTab,
                          onTap: navigateToPage),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
