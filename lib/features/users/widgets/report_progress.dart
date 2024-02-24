import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/my_timeline_tile.dart';
import 'package:balagh/model/report.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReportProgress extends StatefulWidget {
  const ReportProgress({super.key, required this.report});

  final Report report;

  @override
  State<ReportProgress> createState() => _ReportProgressState();
}

class _ReportProgressState extends State<ReportProgress> {
  String get locationImage {
    final lat = widget.report.location!.latitude;
    final lng = widget.report.location!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=15&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=API_KEY';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Ionicons.arrow_undo,
            color: kMidtBlue,
            size: 26,
          ),
        ),
        title: Text(
          'Progress',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: kMidtBlue, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Container(
            height: SizeConfig.defaultSize! * 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 4),
                ),
              ],
              color: kWhite,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      bottomLeft: Radius.circular(32)),
                  child: Image.network(
                    locationImage,
                    fit: BoxFit.cover,
                    width: SizeConfig.screenWidth! / 2.2,
                    height: double.infinity,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
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
                                  fontSize: 20),
                        ),
                        Text(
                          widget.report.location!.adress,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: kDarkGrey,
                                  ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              widget.report.firstImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.defaultSize! * 3),
          SizedBox(
            height: SizeConfig.defaultSize! * 30,
            child: ListView(
              children: [
                MyTimeLineTile(
                    isFirst: true,
                    isLast: false,
                    isPast: widget.report.currentState == 'fixed',
                    eventText: '${widget.report.type} is fixed'),
                MyTimeLineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: widget.report.currentState == 'reported' ||
                      widget.report.currentState == 'fixed',
                  eventText: 'Local Authorities received your report!',
                ),
                const MyTimeLineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: true,
                  eventText: 'The report is being verified',
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
