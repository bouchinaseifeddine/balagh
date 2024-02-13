import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:balagh/cubits/onboarding_cubit/onboarding_states.dart';
import 'package:balagh/features/auth/presentation/login_view.dart';
import 'package:balagh/features/onboarding/presentation/onboarding_view.dart';
import 'package:balagh/features/users/user_navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with TickerProviderStateMixin {
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;
  late AnimationController _controller1;
  late Animation<Offset> _animation1;
  late AnimationController _controller2;
  late Animation<Offset> _animation2;

  @override
  void initState() {
    super.initState();

    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_opacityController);

    _opacityController.forward();

    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final curvedAnimation1 = CurvedAnimation(
      parent: _controller1,
      curve: Curves.easeInOut,
    );

    final curvedAnimation2 = CurvedAnimation(
      parent: _controller2,
      curve: Curves.easeInOut,
    );

    _animation1 = Tween<Offset>(
      begin: const Offset(-1, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(curvedAnimation1);

    _controller1.forward();

    _animation2 = Tween<Offset>(
      begin: const Offset(7, 0),
      end: const Offset(0.0, 0.0),
    ).animate(curvedAnimation2);

    _controller2.forward();

    // moving to the next page after delay
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 700),
          type: PageTransitionType.rightToLeftWithFade,
          curve: Curves.easeInOut,
          // onboardingview screen will be shown only once
          // when the user open the app for the first tiem

          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              if (state is OnboardingShownState) {
                return StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return const UserNavigation();
                      }
                      return const LoginView();
                    });
              } else if (state is OnboardingInitialState) {
                return const OnboardingView();
              } else {
                return const Text('somthing went wrong..');
              }
            },
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _animation1,
              child: Text(
                'BALAGH',
                style: GoogleFonts.nerkoOne(
                  fontSize: 59,
                  fontWeight: FontWeight.w600,
                  color: kDeepBlue,
                  letterSpacing: -0.8,
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const SizedBox(width: 5),
          FadeTransition(
            opacity: _opacityAnimation,
            child: SlideTransition(
              position: _animation2,
              child: Text(
                '!',
                style: GoogleFonts.nerkoOne(
                  fontSize: 59,
                  fontWeight: FontWeight.w600,
                  color: kMidtBlue,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
