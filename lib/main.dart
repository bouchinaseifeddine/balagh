import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:balagh/core/themes/app_theme.dart';
import 'package:balagh/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:balagh/features/splash/presentation/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  OnboardingCubit onboardingCubit = OnboardingCubit();
  await onboardingCubit.initialize();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
        BlocProvider<UserCubit>(
          create: (BuildContext context) => UserCubit(),
        ),
      ],
      child: const Balagh(),
    ),
  );
}

class Balagh extends StatelessWidget {
  const Balagh({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      home: const SplashView(),
    );
  }
}
