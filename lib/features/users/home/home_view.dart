import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/shared/custom_buttons.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/nearby_report.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.navigateToPage});

  final Function navigateToPage;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    List<String> nearbyReports = [
      'Report 1',
      'Report 2',
      'Report 3',
      'Report 4',
      'Report 5',
      // Add more reports
    ];
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
                border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                color: kWhite,
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
            SizedBox(height: SizeConfig.defaultSize! * 4),
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
                    'View all',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: kDarkBlue,
                        ),
                  ),
                )
              ],
            ),
            SizedBox(height: SizeConfig.defaultSize! * 3),
            Container(
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: SizedBox(
                height: SizeConfig.defaultSize! * 18,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/pothole.JPG',
                          fit: BoxFit.fill,
                          height: double.infinity,
                          width: (SizeConfig.screenWidth! - 80) / 2.7,
                        ),
                      ),
                      SizedBox(width: SizeConfig.defaultSize! * 1.5),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pot Hole',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: kMidtBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Ionicons.calendar_outline),
                                const SizedBox(width: 8),
                                Text(
                                  'Date',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: kDarkBlue,
                                      ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Ionicons.location_outline),
                                const SizedBox(width: 8),
                                Text(
                                  'Location',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: kDarkBlue,
                                      ),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.flame_outline,
                                      color: kMidtBlue,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '10',
                                      style: TextStyle(color: kMidtBlue),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Ionicons.chatbubbles_outline,
                                      color: kMidtBlue,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '10',
                                      style: TextStyle(color: kMidtBlue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.defaultSize! * 3),
                      const Icon(
                        Icons.miscellaneous_services_outlined,
                        size: 42,
                        color: kMidtBlue,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.defaultSize! * 3),
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
            SizedBox(height: SizeConfig.defaultSize! * 3),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: nearbyReports.length,
              itemBuilder: (context, index) {
                return NearbyReport(reportTitle: nearbyReports[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
