import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/report_card.dart';
import 'package:balagh/core/shared/report_comments.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserReports(),
      builder: (context, AsyncSnapshot<List<Report>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            color: kMidtBlue,
          ));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reports found.'));
        } else {
          final reports = snapshot.data!;
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  return ReportCard(
                      report: reports[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            duration: const Duration(milliseconds: 300),
                            type: PageTransitionType.fade,
                            curve: Curves.easeInOut,
                            child: ReportCommentsView(
                              report: reports[index],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<List<Report>> fetchUserReports() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('reports')
        .where('userid', isEqualTo: user?.uid)
        .get();

    return snapshot.docs.map((doc) {
      return Report(
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
      );
    }).toList();
  }
}
