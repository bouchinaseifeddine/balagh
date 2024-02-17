import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/report_comments.dart';
import 'package:balagh/model/report.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:page_transition/page_transition.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              duration: const Duration(milliseconds: 300),
              type: PageTransitionType.fade,
              curve: Curves.easeInOut,
              child: ReportCommentsView(
                report: report,
              ),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: kWhite,
            // border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(1, 4),
              ),
            ],
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
                      report.firstImage,
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
                              report.type,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: kMidtBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                            ),
                            Text(
                              report.location!.adress,
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
                                  '${report.likes}',
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
                                  '${report.comments?.length}' == 'null'
                                      ? '0'
                                      : '${report.comments?.length}',
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
                    stateIcons[report.currentState],
                    size: 32,
                    color: kMidtBlue,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
