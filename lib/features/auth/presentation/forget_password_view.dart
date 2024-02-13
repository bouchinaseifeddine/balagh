import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

final _firebase = FirebaseAuth.instance;

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  var _entredEmail = '';
  var _isAuthenticating = false;

  // used to hide the keyboard when the user press reset my password
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  void _reset() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _firebase.sendPasswordResetEmail(email: _entredEmail.trim());

      // we use context mounted to check if the current widget is still visible on the screen
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Password reset link sent! Check your email'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1000),
        margin: EdgeInsets.only(
          bottom: SizeConfig.screenHeight! - 90,
          left: 10,
          right: 10,
        ),
        backgroundColor: kLightBlue,
        showCloseIcon: true,
      ));

      setState(() {
        _isAuthenticating = false;
      });
    } on FirebaseAuthException catch (error) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text(error.message ?? 'Authentication Failed.'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: kMidtBlue),
      ),
      body: SizedBox(
        height: SizeConfig.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.defaultSize! * 9.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'BALAGH',
                    style: GoogleFonts.nerkoOne(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: kDeepBlue,
                      letterSpacing: -0.8,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '!',
                    style: GoogleFonts.nerkoOne(
                      fontSize: 50,
                      fontWeight: FontWeight.w600,
                      color: kMidtBlue,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.defaultSize! * 2),
              Text(
                'Forget Password',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: kDarkBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  'Enter your email to receive a password reset link',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: kDarkBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 3),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      style: textStyleInput,
                      focusNode: _focusNode,
                      onSaved: (value) {
                        _entredEmail = value!;
                      },
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'This field is required';
                        }
                        if (value != null &&
                            value.isNotEmpty &&
                            !StringUtil.isValidEmail(value)) {
                          return 'The email is invalid';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                        hintText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 3.3),
                    CustomButtonWithIcon(
                      onTap: () {
                        _focusNode.unfocus();
                        _reset();
                      },
                      text: 'Reset my password',
                      iconData: Icons.arrow_forward_ios_rounded,
                      color: kWhite,
                      fontSize: 16,
                      backgroundColor: kMidtBlue,
                      isLoading: _isAuthenticating,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
