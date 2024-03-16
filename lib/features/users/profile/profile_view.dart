import 'dart:io';
import 'package:balagh/cubits/user_cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/shared/sign_out.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/user_image_picker.dart';
import 'package:balagh/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfileView> {
  final _formkey = GlobalKey<FormState>();
  File? _selectedImage;
  var _isAuthenticating = false;
  appUser? user;
  String? _entredUserName;
  String? _entredAdress;
  int totalReports = 0;
  int totalSupports = 0;
  int totalComments = 0;

  var isLightmode = false;

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  void _save() async {
    final isValid = _formkey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formkey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      var userAuthenticated = FirebaseAuth.instance.currentUser!;

      var imageUrl = '';
      if (_selectedImage != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userAuthenticated.uid}.jpg');
        await storageRef.putFile(_selectedImage!);
        imageUrl = await storageRef.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(userAuthenticated.uid)
            .update({
          'username': _entredUserName,
          'address': _entredAdress,
          'image_url': imageUrl,
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(userAuthenticated.uid)
            .update({
          'username': _entredUserName,
          'address': _entredAdress,
        });
      }

      // we use context mounted to check if the current widget is still visible on the screen
      if (!context.mounted) {
        return;
      }
      BlocProvider.of<UserCubit>(context).updateUser(userAuthenticated.uid);

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Informations Saved'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1000),
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
          SnackBar(content: Text(error.message ?? 'Authentication Failed.')));

      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _addressController.dispose();
    _userNameController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> fetchData() async {
    try {
      final userAuthenticated = FirebaseAuth.instance.currentUser!;
      user = await getUserData(userAuthenticated.uid);
      _addressController.text = user!.address;
      _userNameController.text = user!.userName;

      final QuerySnapshot<Map<String, dynamic>> commentsSnapShot =
          await FirebaseFirestore.instance
              .collection('comments')
              .where('userId', isEqualTo: userAuthenticated.uid)
              .get();

      final QuerySnapshot<Map<String, dynamic>> reportsSnapShot =
          await FirebaseFirestore.instance
              .collection('reports')
              .where('userid', isEqualTo: userAuthenticated.uid)
              .get();

      final QuerySnapshot<Map<String, dynamic>> supportsSnapShot =
          await FirebaseFirestore.instance
              .collection('supports')
              .where('userId', isEqualTo: userAuthenticated.uid)
              .get();

      totalComments = commentsSnapShot.size;
      totalReports = reportsSnapShot.size;
      totalSupports = supportsSnapShot.size;
      return true;
    } catch (error) {
      print('Error fetching data: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Ionicons.arrow_undo,
            color: kBlack,
            size: 26,
          ),
        ),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: kBlack,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
        ),
      ),
      // body:
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the data
            return const Center(
              child: CircularProgressIndicator(color: kMidtBlue),
            );
          } else if (snapshot.hasError || snapshot.data != true) {
            // Handle error state
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(
                              color: kDarkGrey.withOpacity(0.4), width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        margin:
                            EdgeInsets.only(top: SizeConfig.defaultSize! * 5),
                        child: Padding(
                          padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
                          child: Column(
                            children: [
                              UserImagePicker(
                                  onPickImage: (pickedImage) {
                                    _selectedImage = pickedImage;
                                  },
                                  imageUrl: user!.imageUrl),
                              SizedBox(height: SizeConfig.defaultSize),
                              Text(
                                user!.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: kMidtBlue,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                              ),
                              SizedBox(height: SizeConfig.defaultSize! * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        totalReports.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: kMidtBlue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const Text(
                                        'Report',
                                        style: TextStyle(
                                            color: kDeepBlue,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: SizeConfig.defaultSize! * 1.5),
                                  Container(
                                    height: SizeConfig.defaultSize! * 3,
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                      width: SizeConfig.defaultSize! * 1.5),
                                  Column(
                                    children: [
                                      Text(
                                        totalComments.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: kMidtBlue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const Text(
                                        'Comment',
                                        style: TextStyle(
                                            color: kDeepBlue,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      width: SizeConfig.defaultSize! * 1.5),
                                  Container(
                                    height: SizeConfig.defaultSize! * 3,
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                      width: SizeConfig.defaultSize! * 1.5),
                                  Column(
                                    children: [
                                      Text(
                                        totalSupports.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: kMidtBlue,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const Text(
                                        'Support',
                                        style: TextStyle(
                                            color: kDeepBlue,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 3),
                      Text(
                        'Overview',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: kMidtBlue,
                            fontSize: 26,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 3),
                      Container(
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(
                              color: kDarkGrey.withOpacity(0.4), width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          style: textStyleInput,
                          initialValue: user?.email,
                          decoration: const InputDecoration(
                            fillColor: kWhite,
                            prefixIcon: Icon(Icons.mail_outline),
                            suffixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 2),
                      Container(
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(
                              color: kDarkGrey.withOpacity(0.4), width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: TextFormField(
                          controller: _userNameController,
                          style: textStyleInput,
                          onSaved: (value) {
                            _entredUserName = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This field is required';
                            }
                            if (value.trim().length > 10) {
                              return 'Username is too long';
                            }
                            if (value.trim().length < 4) {
                              return 'Username must be at least 4 characters long';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            fillColor: kWhite,
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.account_circle_outlined),
                            suffixIcon: Icon(Icons.create),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 2),
                      Container(
                        decoration: BoxDecoration(
                          color: kWhite,
                          border: Border.all(
                              color: kDarkGrey.withOpacity(0.4), width: 2),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: TextFormField(
                          controller: _addressController,
                          onSaved: (value) {
                            _entredAdress = value!;
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'This field is required';
                            }

                            if (value.trim().length < 4) {
                              return 'Adress must be at least 4 characters long';
                            }
                            return null;
                          },
                          focusNode: _focusNode,
                          style: textStyleInput,
                          decoration: const InputDecoration(
                            fillColor: kWhite,
                            hintText: 'Adress',
                            prefixIcon: Icon(Ionicons.location_outline),
                            suffixIcon: Icon(Icons.create),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.defaultSize! * 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                            onTap: () {
                              _focusNode.unfocus();
                              _save();
                            },
                            width: 120,
                            height: 50,
                            isLoading: _isAuthenticating,
                            text: 'Save',
                            color: kWhite,
                            fontSize: 16,
                            backgroundColor: kMidtBlue,
                          ),
                          CustomButtonWithIcon(
                            onTap: () {
                              _focusNode.unfocus();
                              signOut(context);
                            },
                            width: 120,
                            text: 'Sign Out',
                            color: kMidtBlue,
                            iconData: Icons.logout,
                            height: 50,
                            borderColor: kMidtBlue,
                            fontSize: 16,
                            backgroundColor: kWhite,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
