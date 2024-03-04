import 'package:balagh/features/admin/admin_navigation.dart';
import 'package:balagh/features/auth/presentation/forget_password_view.dart';
import 'package:balagh/features/authorities/authorities_navigation.dart';
import 'package:balagh/features/users/user_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/features/auth/presentation/signup_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

final _firebase = FirebaseAuth.instance;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginView> {
  // This holds the state of the checkbox, we call setState and update this whenever a user taps the checkbox
  bool _isChecked = false;

  var _isAuthenticating = false;
  var _entredEmail = '';
  var _entredPassword = '';

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  //Initially password is obscure
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
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

      // ignore: unused_local_variable
      final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _entredEmail, password: _entredPassword);

      setState(() {
        _isAuthenticating = false;
      });

      _nextPage();
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password') {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Text('Wrong password. try again'),
            duration: Duration(seconds: 3),
            showCloseIcon: true,
          ),
        );
      } else if (error.code == 'invalid-email') {
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Text('Invalid email. try again'),
            duration: Duration(seconds: 3),
            showCloseIcon: true,
          ),
        );
      } else {
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
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: kWhite,
              onPressed: () => ScaffoldMessenger.of(context).clearSnackBars(),
            ),
          ),
        );
      }

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void _nextPage() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebase.currentUser!.uid)
        .get();
    final role = snapshot.data()?['role'];
    if (!context.mounted) {
      return;
    }
    switch (role) {
      case 'user':
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const UserNavigation()));
        break;
      case 'admin':
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const AdminNavigation()));
      case 'SEAAL' || 'Sonelgaz' || 'Town hall':
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const AuthoritiesNavigation()));
      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: kWhite,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                  'Welcome back',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: kDarkBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'sign in with your existing account',
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
                        controller: _emailController,
                        style: textStyleInput,
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
                          hintText: 'Enter your email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          _entredEmail = value!;
                        },
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 1.6),
                      TextFormField(
                        validator: (String? value) {
                          if (value != null && value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                        style: textStyleInput,
                        controller: _passwordController,
                        obscureText: _obscureText,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            CupertinoIcons.lock,
                          ),
                          hintText: 'Enter your password',
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
                        onSaved: (value) {
                          _entredPassword = value!;
                        },
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 1.6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                shape: const ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                value: _isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _isChecked = value!;
                                  });
                                },
                                activeColor: kDarkBlue,
                              ),
                              Text(
                                'Remenber me',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: 13,
                                        color: kDarkGrey,
                                        fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  duration: const Duration(milliseconds: 400),
                                  type: PageTransitionType.fade,
                                  curve: Curves.easeInOut,
                                  child: const ForgetPasswordView(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                'Forgot password?',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(
                                        fontSize: 14,
                                        color: kMidtBlue,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.defaultSize! * 2.3),
                CustomButtonWithIcon(
                  onTap: () {
                    _focusNode.unfocus();
                    _submit();
                  },
                  text: 'Sign in',
                  iconData: Icons.login_rounded,
                  color: kWhite,
                  fontSize: 16,
                  backgroundColor: kMidtBlue,
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
                        child: const SignupView(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have account? ',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontSize: 14,
                          color: const Color(0xFF24282C),
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Register now',
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
          ),
        ),
      ),
    );
  }
}
