import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/model/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReportCard extends StatefulWidget {
  const ReportCard({super.key, required this.report, required this.onTap});

  final Report report;
  final void Function() onTap;

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  int totalComments = 0;
  int totalSupports = 0;
  @override
  void initState() {
    super.initState();
    fetchSatatistics();
  }

  void fetchSatatistics() async {
    final QuerySnapshot<Map<String, dynamic>> commentsSnapShot =
        await FirebaseFirestore.instance
            .collection('comments')
            .where('reportId', isEqualTo: widget.report.reportId)
            .get();

    final QuerySnapshot<Map<String, dynamic>> supportsSnapShot =
        await FirebaseFirestore.instance
            .collection('likes')
            .where('reportId', isEqualTo: widget.report.reportId)
            .get();

    setState(() {
      totalComments = commentsSnapShot.size;
      totalSupports = supportsSnapShot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: kWhite,
          border: Border.all(color: kDarkGrey.withOpacity(0.4), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          height: SizeConfig.defaultSize! * 11,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.report.firstImage,
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: (SizeConfig.screenWidth! - 80) / 3.2,
                  ),
                ),
                SizedBox(width: SizeConfig.defaultSize! * 1.5),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.report.type,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: kMidtBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                          ),
                          Text(
                            widget.report.location!.adress,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: kDarkBlue,
                                    overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Ionicons.flame_outline,
                                color: kMidtBlue,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                totalSupports.toString(),
                                style: const TextStyle(color: kMidtBlue),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Ionicons.chatbubbles_outline,
                                color: kMidtBlue,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                totalComments.toString(),
                                style: const TextStyle(color: kMidtBlue),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: SizeConfig.defaultSize! * 3),
                Icon(
                  stateIcons[widget.report.currentState],
                  size: 32,
                  color: kMidtBlue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
