import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/data/categories.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/admin/admin_navigation.dart';
import 'package:balagh/model/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReportValidation extends StatefulWidget {
  const ReportValidation({super.key, required this.report});

  final Report report;

  @override
  State<ReportValidation> createState() => _ReportValidationState();
}

class _ReportValidationState extends State<ReportValidation> {
  String? _selectedType;
  String? _entredDescription;
  bool? _isUrgent;
  var _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _isUrgent = widget.report.isUrgent;
  }

  // used to hide the keyboard when the user press submit
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  void approve() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isAuthenticating = true;
      });

      DocumentReference reportRef = FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.report.reportId);

      reportRef.update({
        'currentState': 'reported',
        'type': _selectedType ?? widget.report.type,
        'description': _entredDescription != ''
            ? _entredDescription
            : widget.report.description,
        'isurgent': _isUrgent,
      }).then((_) {
        setState(() {
          _isAuthenticating = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Report has been approved successfully"),
            duration: Duration(seconds: 3),
            showCloseIcon: true,
            backgroundColor: kLightBlue,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AdminNavigation()),
          (route) => false,
        );
      }).catchError((error) {
        // Error handling
        setState(() {
          _isAuthenticating = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            content: Text("Failed to update report: $error"),
            duration: const Duration(seconds: 3),
            showCloseIcon: true,
          ),
        );
      });
    }
  }

  void deleteReport() async {
    setState(() {
      _isAuthenticating = true;
    });

    DocumentReference reportRef = FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.report.reportId);

    // deleting the comments of this report
    final QuerySnapshot commentsSnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('reportId', isEqualTo: widget.report.reportId)
        .get();
    for (final doc in commentsSnapshot.docs) {
      await doc.reference.delete();
    }

    // deleting the image of the report
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('reports_images/${widget.report.reportId}.jpg');
    storageRef.delete();

    // deleting the report it self
    reportRef.delete().then((_) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Report has been deleted successfully"),
          duration: Duration(seconds: 3),
          showCloseIcon: true,
          backgroundColor: kLightBlue,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminNavigation()),
        (route) => false,
      );
    }).catchError((error) {
      setState(() {
        _isAuthenticating = false;
      });
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          content: Text("Failed to delete report: $error"),
          duration: const Duration(seconds: 3),
          showCloseIcon: true,
        ),
      );
    });
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
          child: Column(children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: kWhite,
                  border:
                      Border.all(color: kDarkGrey.withOpacity(0.4), width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
              child: Image(
                image: NetworkImage(widget.report.firstImage),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kDarkGrey.withOpacity(0.4), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('ID:', style: TextStyle(color: kDarkBlue)),
                        const SizedBox(width: 8),
                        Text(
                          widget.report.reportId,
                          style: const TextStyle(
                            color: kMidtBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Reported by:',
                            style: TextStyle(color: kDarkBlue)),
                        const SizedBox(width: 8),
                        Text(
                          widget.report.userId,
                          style: const TextStyle(
                            color: kMidtBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Created at:',
                          style: TextStyle(color: kDarkBlue),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.report.dateOfReporting.toString(),
                          style: const TextStyle(
                            color: kMidtBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Location:',
                            style: TextStyle(color: kDarkBlue)),
                        const SizedBox(width: 8),
                        Text(
                          widget.report.location!.adress,
                          style: const TextStyle(
                            color: kMidtBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Likes:',
                            style: TextStyle(color: kDarkBlue)),
                        const SizedBox(width: 8),
                        Text(
                          widget.report.likes.toString(),
                          style: const TextStyle(
                            color: kMidtBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (widget.report.currentState == 'pending')
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        fillColor: kWhite,
                      ),
                      value: widget.report.type,
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
                          _selectedType = value! as String?;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  if (widget.report.currentState == 'pending')
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                          fillColor: kWhite,
                          hintText: widget.report.description),
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
                          if (widget.report.currentState == 'pending')
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
                          if (widget.report.currentState == 'pending')
                            const Text(
                              'Urgent',
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          if (widget.report.currentState != 'pending')
                            CustomButton(
                              text: 'Delete',
                              width: 120,
                              backgroundColor: Colors.redAccent,
                              color: kWhite,
                              height: 50,
                              fontSize: 18,
                              onTap: () {
                                deleteReport();
                              },
                              isLoading: _isAuthenticating,
                            ),
                          if (widget.report.currentState == 'pending')
                            IconButton(
                              onPressed: () {
                                deleteReport();
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (widget.report.currentState == 'pending')
                            CustomButton(
                              text: 'Approve',
                              width: 120,
                              backgroundColor: kMidtBlue,
                              color: kWhite,
                              height: 50,
                              fontSize: 18,
                              onTap: () {
                                _focusNode.unfocus();
                                approve();
                              },
                              isLoading: _isAuthenticating,
                            ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize!),
                ],
              ),
            ),
          ])),
    );
  }
}
