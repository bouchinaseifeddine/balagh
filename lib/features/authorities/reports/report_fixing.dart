import 'dart:io';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/image_input.dart';
import 'package:balagh/model/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReportFixing extends StatefulWidget {
  const ReportFixing({super.key, required this.report});

  final Report report;

  @override
  State<ReportFixing> createState() => _ReportFixingState();
}

class _ReportFixingState extends State<ReportFixing> {
  File? _selectedImage;
  var _isAuthenticating = false;

  String get locationImage {
    final lat = widget.report.location!.latitude;
    final lng = widget.report.location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCdIq65pwy2KoNBa42AhnecTG3wZN5j4EQ';
  }

  void _showReportAddedDialog(ctx) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          title: const Text('Report has been Fixed'),
          content: const Text('Thank you for your services.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void submit() async {
    if (_selectedImage == null) {
      return;
    }

    try {
      setState(() {
        _isAuthenticating = true;
      });

      Timestamp currentTime = Timestamp.fromDate(DateTime.now());

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reports_images')
          .child('${widget.report.reportId}-2.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.report.reportId)
          .update({
        'secondimageUrl': imageUrl,
        'fixingdate': currentTime,
        'currentState': 'fixed',
      });

      setState(() {
        _isAuthenticating = false;
      });

      _showReportAddedDialog(context);
    } catch (error) {
      setState(() {
        _isAuthenticating = false;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text('Error submiting: $error'),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Ionicons.arrow_undo,
              color: kMidtBlue,
              size: 26,
            ),
          ),
          title: Text(
            widget.report.type,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: kMidtBlue, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhite,
                  border:
                      Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        locationImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(height: SizeConfig.defaultSize! * 2),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'State ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: kDarkGrey,
                                      ),
                                ),
                                Text(
                                  widget.report.isUrgent ? 'Urgent' : 'Normal',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: kDarkBlue,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: kDarkGrey,
                                      ),
                                ),
                                Text(
                                  widget.report.location!.adress,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: kDarkBlue,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.defaultSize),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reported at:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: kDarkGrey,
                                      ),
                                ),
                                Text(
                                  widget.report.formattedDateOfReporting,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: kDarkBlue,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 2),
              ImageInput(
                onPickImage: (image) {
                  _selectedImage = image;
                },
              ),
              SizedBox(height: SizeConfig.defaultSize! * 2),
              CustomButtonWithIcon(
                text: 'Submit',
                iconData: Icons.done,
                backgroundColor: kMidtBlue,
                color: kWhite,
                fontSize: 18,
                onTap: () {
                  submit();
                },
                isLoading: _isAuthenticating,
              )
            ],
          ),
        ));
  }
}
