import 'dart:io';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/data/categories.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/add_report/image_input.dart';
import 'package:balagh/features/users/add_report/location_input.dart';
import 'package:balagh/model/report_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddReportView extends StatefulWidget {
  const AddReportView({super.key});

  @override
  State<AddReportView> createState() => _AddReportViewState();
}

class _AddReportViewState extends State<AddReportView> {
  File? _selectedImage;
  String? _selectedType;
  String? _entredDescription;
  bool _isUrgent = false;
  ReportLocation? reportLocation;
  var _isAuthenticating = false;

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  void setLocation(location) {
    reportLocation = location;
  }

  void _showReportAddedDialog(ctx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          title: const Text('Report Added'),
          content: const Text(
              'Thank you for your report. We will review it as soon as possible'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(ctx).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addReport() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || reportLocation == null || _selectedImage == null) {
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });

      GeoPoint geoPoint =
          GeoPoint(reportLocation!.latitude, reportLocation!.longitude);

      Timestamp currentTime = Timestamp.fromDate(DateTime.now());
      DocumentReference reportRef =
          await FirebaseFirestore.instance.collection('reports').add({
        'userid': FirebaseAuth.instance.currentUser!.uid,
        'type': _selectedType,
        'firstimageUrl': '',
        'reportingdate': currentTime,
        'description': _entredDescription,
        'currentState': 'pending',
        'isurgent': _isUrgent,
        'location': geoPoint,
        'adress': reportLocation!.adress,
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports_images')
          .child('${reportRef.id}.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await reportRef.update({'firstimageUrl': imageUrl});

      setState(() {
        _isAuthenticating = false;
      });

      _showReportAddedDialog(context);
    } catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text('Error adding report: $error'),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Report',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: kMidtBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.defaultSize! * 2),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  LocationInput(onSetLocation: setLocation),
                  const SizedBox(height: 16),
                  ImageInput(
                    onPickImage: (image) {
                      _selectedImage = image;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField(
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a type';
                      }
                      return null;
                    },
                    hint: const Text('Report Type'),
                    decoration: const InputDecoration(
                      fillColor: kWhite,
                    ),
                    value: _selectedType,
                    items: [
                      for (final category in categories)
                        DropdownMenuItem(
                          value: category,
                          child: Row(children: [
                            Text(category),
                          ]),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 2,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      fillColor: kWhite,
                      hintText: 'Enter description',
                    ),
                    onSaved: (value) {
                      _entredDescription = value;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            shape: const ContinuousRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            value: _isUrgent,
                            onChanged: (value) {
                              setState(() {
                                _isUrgent = value!;
                              });
                            },
                            activeColor: kDarkBlue,
                          ),
                          const Text(
                            'Urgent',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      CustomButtonWithIcon(
                        text: 'Report',
                        iconData: Icons.campaign,
                        width: 120,
                        backgroundColor: kMidtBlue,
                        color: kWhite,
                        height: 50,
                        fontSize: 18,
                        onTap: () {
                          _focusNode.unfocus();
                          _addReport();
                        },
                        isLoading: _isAuthenticating,
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
