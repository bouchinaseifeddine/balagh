import 'package:balagh/features/admin/accounts/accounts_view.dart';
import 'package:balagh/features/admin/reports/reports_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:balagh/cubits/user_cubit/user_states.dart';
import 'package:balagh/features/users/profile/profile_view.dart';
import 'package:balagh/features/users/widgets/navbar_item.dart';
import 'package:balagh/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminNavigation extends StatefulWidget {
  const AdminNavigation({super.key});

  @override
  State<AdminNavigation> createState() => _UserNavigationState();
}

class _UserNavigationState extends State<AdminNavigation> {
  int _currentTab = 0;
  appUser? user;

  late PageController _pageController;

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
      case 0:
        return 'Reports';
      case 1:
        return 'Accounts';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ReportsView(),
      const AccountsView(),
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
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  NavbarItem(
                      index: 0,
                      icon: Icons.report,
                      label: 'Reports',
                      currentTab: _currentTab,
                      onTap: navigateToPage),
                  NavbarItem(
                      index: 1,
                      icon: Icons.supervisor_account_sharp,
                      label: 'Accounts',
                      currentTab: _currentTab,
                      onTap: navigateToPage),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
