import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/admin/reports/report_validation.dart';
import 'package:balagh/core/shared/report_card.dart';
import 'package:balagh/model/report.dart';
import 'package:balagh/model/report_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  var _selectedTab = 1;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
            onPressed: () {
              setState(() {
                _selectedTab = 1;
              });
            },
            child: Text('Pending',
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
            child: Text('Reported',
                style: TextStyle(
                    color: _selectedTab == 2 ? kMidtBlue : kDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))),
        SizedBox(width: SizeConfig.defaultSize),
        TextButton(
            onPressed: () {
              setState(() {
                _selectedTab = 3;
              });
            },
            child: Text('Fixed',
                style: TextStyle(
                    color: _selectedTab == 3 ? kMidtBlue : kDarkGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))),
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
              return Padding(
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
                              child: ReportValidation(report: reports[index]),
                            ),
                          );
                        });
                  },
                ),
              );
            }
          },
        ),
      ),
    ]);
  }

  Future<List<Report>> fetchReports() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot;
    if (_selectedTab == 1) {
      snapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('currentState', isEqualTo: 'pending')
          .get();
    } else if (_selectedTab == 2) {
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
          secondImage: doc['secondimageUrl'],
          isUrgent: doc['isurgent'],
          dateOfReporting: doc['reportingdate'].toDate(),
          dateOfFixing: doc['fixingdate'].toDate(),
          location: ReportLocation(
              adress: doc['adress'],
              latitude: doc['location'].latitude,
              longitude: doc['location'].longitude),
          currentState: doc['currentState'],
          likes: doc['likes']);
    }).toList();
  }
}
