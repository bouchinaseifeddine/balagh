import 'package:balagh/features/authorities/reports/reports_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:balagh/cubits/user_cubit/user_states.dart';
import 'package:balagh/features/users/profile/profile_view.dart';
import 'package:balagh/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthoritiesNavigation extends StatefulWidget {
  const AuthoritiesNavigation({super.key});

  @override
  State<AuthoritiesNavigation> createState() => _AuthoritiesNavigationState();
}

class _AuthoritiesNavigationState extends State<AuthoritiesNavigation> {
  appUser? user;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final userAuthenticated = FirebaseAuth.instance.currentUser!;
      user = await getUserData(userAuthenticated.uid);
      setState(() {});
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reports',
                    style: TextStyle(
                      color: kBlack,
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
        body: ReportsView(user: user),
      );
    });
  }
}
