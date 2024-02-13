import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/features/users/widgets/report_card.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder(
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
            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                return ReportCard(report: reports[index]);
              },
            );
          }
        },
      ),
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
        isUrgent: doc['isurgent'],
        dateOfReporting: doc['reportingdate'].toDate(),
        location: ReportLocation(
            adress: doc['adress'],
            latitude: doc['location'].latitude,
            longitude: doc['location'].longitude),
        currentState: doc['currentState'],
      );
    }).toList();
  }
}
