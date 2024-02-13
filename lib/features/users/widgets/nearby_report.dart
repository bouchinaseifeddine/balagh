import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:flutter/material.dart';

class NearbyReport extends StatelessWidget {
  const NearbyReport({super.key, required this.reportTitle});

  final String reportTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.defaultSize! * 2),
      decoration: BoxDecoration(
        color: kWhite,
        border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SizedBox(
        height: SizeConfig.defaultSize! * 10,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                reportTitle,
                style: const TextStyle(color: kDarkBlue, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
