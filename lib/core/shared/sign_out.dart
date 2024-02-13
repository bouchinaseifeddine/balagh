import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:balagh/features/auth/presentation/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) {
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
      (route) => false,
    );
    context.read<UserCubit>().resetUser();
  } catch (e) {
    print('Error signing out: $e');
  }
}
