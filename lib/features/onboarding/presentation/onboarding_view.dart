import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/features/onboarding/presentation/widgets/onboarding_body.dart';
import 'package:flutter/material.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kWhite,
      body: OnBoardingBody(),
    );
  }
}
