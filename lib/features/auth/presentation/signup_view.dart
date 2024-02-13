import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/auth/presentation/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

final _firebase = FirebaseAuth.instance;

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  //Initially password is obscure
  bool _obscureText = true;

  var _isAuthenticating = false;
  var _entredEmail = '';
  var _entredPassword = '';
  var _entredUserName = '';

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _entredEmail, password: _entredPassword);

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredentials.user!.uid)
          .set({
        'username': _entredUserName,
        'email': _entredEmail,
        'role': 'user',
        'image_url': '',
      });

      // we use context mounted to check if the current widget is still visible on the screen
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Account Created Successfully'),
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

      Navigator.pushReplacement(
        context,
        PageTransition(
          duration: const Duration(milliseconds: 400),
          type: PageTransitionType.fade,
          curve: Curves.easeInOut,
          child: const LoginView(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}

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
          showCloseIcon: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kWhite,
      body: SizedBox(
        height: SizeConfig.screenHeight,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: SizeConfig.defaultSize! * 9.5),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                  'Get Started',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: kDarkBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    'by creating a free account',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: kDarkBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize! * 3),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        style: textStyleInput,
                        onSaved: (value) {
                          _entredUserName = value!;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          if (value.trim().length < 4) {
                            return 'Username must be at least 4 characters long';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.person),
                          hintText: 'Username',
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 1.6),
                      TextFormField(
                        controller: _emailController,
                        style: textStyleInput,
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
                      SizedBox(height: SizeConfig.defaultSize! * 1.6),
                      TextFormField(
                        controller: _passwordController,
                        onSaved: (value) {
                          _entredPassword = value!;
                        },
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'This field is required';
                          }

                          if (value!.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                        style: textStyleInput,
                        obscureText: _obscureText,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            CupertinoIcons.lock,
                          ),
                          hintText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 2.3),
                      CustomButton(
                        onTap: () {
                          _focusNode.unfocus();
                          _submit();
                        },
                        text: 'Sign up',
                        color: kWhite,
                        backgroundColor: kMidtBlue,
                        fontSize: 16,
                        isLoading: _isAuthenticating,
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 2.5),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              duration: const Duration(milliseconds: 400),
                              type: PageTransitionType.fade,
                              curve: Curves.easeInOut,
                              child: const LoginView(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    fontSize: 14,
                                    color: const Color(0xFF24282C),
                                    fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' Sign In',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                          fontSize: 14,
                                          color: kMidtBlue,
                                          fontWeight: FontWeight.w700))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
