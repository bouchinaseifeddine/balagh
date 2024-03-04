import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class MyTimeLineTile extends StatelessWidget {
  MyTimeLineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      this.date,
      required this.eventText});

  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String eventText;
  String? date;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // for the gap

      height: SizeConfig.defaultSize! * 9,
      child: TimelineTile(
        alignment: TimelineAlign.center,
        startChild: Container(
          margin: const EdgeInsets.only(right: 10),
          child: isPast
              ? Text(
                  date!.toUpperCase(),
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: kMidtBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              : null,
        ),
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? kLightBlue : kDarkGrey,
        ),
        indicatorStyle: IndicatorStyle(
            width: 40,
            color: isPast ? kLightBlue : kDarkGrey,
            iconStyle: IconStyle(
              iconData: Icons.done,
              color: isPast ? kWhite : Colors.transparent,
            )),
        endChild: Container(
          margin: const EdgeInsets.all(10),
          child: Text(
            eventText,
            style: !isPast
                ? const TextStyle(
                    color: kDarkGrey,
                    fontWeight: FontWeight.normal,
                    fontSize: 16)
                : const TextStyle(
                    color: kMidtBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
          ),
        ),
      ),
    );
  }
}
