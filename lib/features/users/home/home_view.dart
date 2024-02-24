import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/shared/get_user_data.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/report_card.dart';
import 'package:balagh/features/users/widgets/report_big_card.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:balagh/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.navigateToPage});

  final Function navigateToPage;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? userReportId;
  Report? userReport;
  List<Report> nearbyReports = [];
  @override
  void initState() {
    super.initState();
    fetchUserReport();
    fetchNearbyReports();
  }

  @override
  Widget build(BuildContext context) {
    print('dsadad $nearbyReports');
    return Padding(
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
                border: Border.all(color: kDarkGrey.withOpacity(0.4), width: 1),
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
                  SizedBox(width: SizeConfig.defaultSize! * 1.5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2k points earned',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: kDarkBlue,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Top 100',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: kDarkGrey,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(width: SizeConfig.defaultSize! * 1.5),
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
                        color: kDarkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                InkWell(
                  onTap: () {
                    widget.navigateToPage(2);
                  },
                  child: Text(
                    'See all',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kDarkBlue,
                        ),
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
                        color: kDarkBlue,
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
                  return ReportCard(report: nearbyReports[index]);
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
      print('userId ${userId}');
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
                isUrgent: userSnapshot.docs.first['isurgent'],
                dateOfReporting:
                    userSnapshot.docs.first['reportingdate'].toDate(),
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
      appUser? userData;

      print('userId ${userId}');
      if (userId != null) {
        userData = await getUserData(userId);
        final reportsSnapShots = await FirebaseFirestore.instance
            .collection('reports')
            .where('currentState', isEqualTo: 'reported')
            .where('userid', isNotEqualTo: userId)
            .get();

        if (reportsSnapShots.docs.isNotEmpty) {
          nearbyReports = reportsSnapShots.docs
              .map((doc) => Report(
                  reportId: doc.id,
                  userId: doc['userid'],
                  type: doc['type'],
                  description: doc['description'],
                  firstImage: doc['firstimageUrl'],
                  isUrgent: doc['isurgent'],
                  dateOfReporting: doc['reportingdate'].toDate(),
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
