import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/core/shared/report_card.dart';
import 'package:balagh/core/shared/report_big_card.dart';
import 'package:balagh/core/shared/report_comments.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.navigateToPage});

  final Function navigateToPage;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? userReportId;
  Report? userReport;
  appUser? user;

  List<Report> nearbyReports = [];
  @override
  void initState() {
    super.initState();
    fetchUserReport();
    fetchNearbyReports();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userAuthenticated = FirebaseAuth.instance.currentUser!;
      user = await getUserData(userAuthenticated.uid);
      setState(() {});
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return user == null
        ? const Center(
            child: CircularProgressIndicator(
              color: kDarkBlue,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.defaultSize! * 8.5,
                    margin: EdgeInsets.only(
                      top: SizeConfig.defaultSize! * 2,
                    ),
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(
                          color: kDarkGrey.withOpacity(0.4), width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.auto_awesome_outlined,
                          color: kDarkBlue,
                        ),
                        SizedBox(width: SizeConfig.defaultSize! * 2),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user!.score.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: kDarkBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              'Points',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: kDarkGrey,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(width: SizeConfig.defaultSize! * 4),
                        CustomButton(
                          onTap: () {
                            widget.navigateToPage(3);
                          },
                          color: kWhite,
                          fontSize: 14,
                          text: 'View Ranking',
                          backgroundColor: kMidtBlue,
                          width: SizeConfig.defaultSize! * 17,
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'My Reports',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          widget.navigateToPage(2);
                        },
                        child: Text(
                          'See all',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 2),
                  if (userReport != null) ReportBigCard(report: userReport!),
                  if (userReport == null)
                    SizedBox(
                      height: SizeConfig.defaultSize! * 10,
                      child: const Center(
                        child: Text(
                          'No report found, Start adding some',
                        ),
                      ),
                    ),
                  SizedBox(height: SizeConfig.defaultSize! * 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Nearby Reports',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.defaultSize! * 1),
                  if (nearbyReports.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: nearbyReports.length,
                      itemBuilder: (context, index) {
                        return ReportCard(
                          report: nearbyReports[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                duration: const Duration(milliseconds: 300),
                                type: PageTransitionType.fade,
                                curve: Curves.easeInOut,
                                child: ReportCommentsView(
                                  report: nearbyReports[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  if (nearbyReports.isEmpty)
                    SizedBox(
                      height: SizeConfig.defaultSize! * 10,
                      child: const Center(
                        child: Text(
                          'No Nearby Reports found.',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }

  Future<void> fetchUserReport() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('reports')
            .where('userid', isEqualTo: userId)
            .get();
        if (userSnapshot.docs.isNotEmpty) {
          setState(() {
            userReport = Report(
                reportId: userSnapshot.docs.first.id,
                userId: userSnapshot.docs.first['userid'],
                type: userSnapshot.docs.first['type'],
                description: userSnapshot.docs.first['description'],
                firstImage: userSnapshot.docs.first['firstimageUrl'],
                secondImage: userSnapshot.docs.first['secondimageUrl'],
                isUrgent: userSnapshot.docs.first['isurgent'],
                dateOfReporting:
                    userSnapshot.docs.first['reportingdate'].toDate(),
                dateOfFixing: userSnapshot.docs.first['fixingdate'].toDate(),
                location: ReportLocation(
                    adress: userSnapshot.docs.first['adress'],
                    latitude: userSnapshot.docs.first['location'].latitude,
                    longitude: userSnapshot.docs.first['location'].longitude),
                currentState: userSnapshot.docs.first['currentState'],
                likes: userSnapshot.docs.first['likes']);
          });
        } else {
          setState(() {
            userReport = null;
          });
        }
      }
    } catch (error) {}
  }

  Future<void> fetchNearbyReports() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final reportsSnapShots = await FirebaseFirestore.instance
            .collection('reports')
            .where('currentState', isEqualTo: 'reported')
            .where('userid', isNotEqualTo: userId)
            .limit(3)
            .get();

        if (reportsSnapShots.docs.isNotEmpty) {
          nearbyReports = reportsSnapShots.docs
              .map((doc) => Report(
                  reportId: doc.id,
                  userId: doc['userid'],
                  type: doc['type'],
                  description: doc['description'],
                  firstImage: doc['firstimageUrl'],
                  secondImage: doc['secondimageUrl'],
                  isUrgent: doc['isurgent'],
                  dateOfReporting: doc['reportingdate'].toDate(),
                  dateOfFixing: doc['fixingdate'].toDate(),
                  location: ReportLocation(
                      adress: doc['adress'],
                      latitude: doc['location'].latitude,
                      longitude: doc['location'].longitude),
                  currentState: doc['currentState'],
                  likes: doc['likes']))
              .toList();
          setState(() {});
        } else {
          nearbyReports = [];
        }
      }
    } catch (error) {
      print('Error fetching user report: $error');
    }
  }
}
