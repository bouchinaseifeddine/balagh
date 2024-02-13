import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:balagh/features/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:page_transition/page_transition.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return OnBoardingSlider(
      onFinish: () async {
        BlocProvider.of<OnboardingCubit>(context).setOnboardingState();
        Navigator.pushReplacement(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 800),
            type: PageTransitionType.rightToLeft,
            curve: Curves.easeInOut,
            child: const AuthView(),
          ),
        );
      },
      finishButtonText: 'Get Started',
      finishButtonStyle: const FinishButtonStyle(
          backgroundColor: kMidtBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)))),
      skipTextButton: const Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: kMidtBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      controllerColor: kMidtBlue,
      centerBackground: true,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'assets/images/onboarding1.png',
          height: SizeConfig.screenHeight! - 400,
        ),
        Image.asset(
          'assets/images/onboarding2.png',
          height: SizeConfig.screenHeight! - 400,
        ),
        Image.asset(
          'assets/images/onboarding3.png',
          height: SizeConfig.screenHeight! - 400,
        ),
      ],
      speed: 1.9,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.screenHeight! - 380,
              ),
              const Text(
                'Report with Ease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kMidtBlue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Snap, Report, and Improve your community effortlessly',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.screenHeight! - 380,
              ),
              const Text(
                'Swift Problem Resolution',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kMidtBlue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Skilled workers promptly address reported issues for a better environment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: SizeConfig.screenWidth,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.screenHeight! - 380,
              ),
              const Text(
                'Top Contributors',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kMidtBlue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Recognition for the three monthly outstanding contributors.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
