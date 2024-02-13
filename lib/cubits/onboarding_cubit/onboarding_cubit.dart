import 'package:balagh/cubits/onboarding_cubit/onboarding_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitialState());

  // Method to set onboarding state to true
  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingShown = prefs.getBool('onboarding_shown') ?? false;

    if (onboardingShown) {
      emit(OnboardingShownState());
    }
  }

  Future<void> setOnboardingState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboarding_shown', true);
  }
}
