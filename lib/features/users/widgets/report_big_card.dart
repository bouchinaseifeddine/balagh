import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/authorities/reports/report_fixing.dart';
import 'package:balagh/features/users/widgets/report_progress.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';

class ReportBigCard extends StatefulWidget {
  const ReportBigCard({super.key, required this.report});

  final Report report;
  @override
  State<ReportBigCard> createState() => _ReportBigCardState();
}

class _ReportBigCardState extends State<ReportBigCard> {
  var _isLiked = false;
  late DocumentReference _reportRef;
  appUser? _reporter;
  appUser? user;

  @override
  void initState() {
    super.initState();
    _reportRef = FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.report.reportId);
    getReporterData();
  }

  void getReporterData() async {
    _reporter = await getUserData(widget.report.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _reporter == null
        ? const Center(child: CircularProgressIndicator(color: kMidtBlue))
        : GestureDetector(
            onTap: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                final userRole = userDoc['role'];

                if (!context.mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  PageTransition(
                    duration: const Duration(milliseconds: 300),
                    type: PageTransitionType.fade,
                    curve: Curves.easeInOut,
                    child: userRole == 'user' ||
                            widget.report.currentState == 'fixed'
                        ? ReportProgress(
                            report: widget.report,
                          )
                        : ReportFixing(
                            report: widget.report,
                          ), // Assuming ReportFixing is the screen for users with a role other than 'user'
                  ),
                );
              }
            },
            child: Container(
              height: SizeConfig.defaultSize! * 38,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(1, 4),
                  ),
                ],
                color: kWhite,
                borderRadius: const BorderRadius.all(Radius.circular(26)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_reporter!.imageUrl != '')
                          CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_reporter!.imageUrl)),
                        if (_reporter!.imageUrl == '')
                          const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/default-profile-picture.jpg')),
                        SizedBox(width: SizeConfig.defaultSize! * 2),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _reporter!.userName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                        color: kMidtBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          stateIcons[widget.report.currentState],
                          size: 32,
                          color: kMidtBlue,
                        ),
                      ],
                    ),
                  ),
                  Image.network(
                    widget.report.firstImage,
                    fit: BoxFit.fill,
                    height: SizeConfig.defaultSize! * 25,
                    width: double.infinity,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            overflow: TextOverflow.ellipsis,
                            widget.report.description,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: kDarkBlue),
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_isLiked) {
                                    _reportRef.update(
                                        {'likes': FieldValue.increment(-1)});
                                    widget.report.likes =
                                        widget.report.likes - 1;
                                    setState(() {
                                      _isLiked = false;
                                    });
                                  } else {
                                    _reportRef.update(
                                        {'likes': FieldValue.increment(1)});
                                    widget.report.likes =
                                        widget.report.likes + 1;
                                    setState(() {
                                      _isLiked = true;
                                    });
                                  }
                                },
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: Tween(begin: 0.0, end: 1.0)
                                          .animate(animation),
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    color: kMidtBlue,
                                    size: 30,
                                    _isLiked
                                        ? Ionicons.flame
                                        : Ionicons.flame_outline,
                                    key: ValueKey(_isLiked),
                                  ),
                                ),
                              ),
                              Text('${widget.report.likes}')
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
          );
  }
}
