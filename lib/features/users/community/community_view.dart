import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/report_card.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  var _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextButton(
              onPressed: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Text('Reported',
                  style: TextStyle(
                      color: _selectedTab == 1 ? kMidtBlue : kDarkGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600))),
          SizedBox(width: SizeConfig.defaultSize),
          TextButton(
              onPressed: () {
                setState(() {
                  _selectedTab = 2;
                });
              },
              child: Text('Fixed',
                  style: TextStyle(
                      color: _selectedTab == 2 ? kMidtBlue : kDarkGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w600)))
        ]),
        SizedBox(height: SizeConfig.defaultSize),
        Expanded(
          child: FutureBuilder(
            future: fetchReports(),
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
        ),
      ]),
    );
  }

  Future<List<Report>> fetchReports() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    if (_selectedTab == 1) {
      snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('currentState', isEqualTo: 'reported')
          .get();
    } else {
      snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('currentState', isEqualTo: 'fixed')
          .get();
    }

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
        likes: doc['likes'],
      );
    }).toList();
  }
}
