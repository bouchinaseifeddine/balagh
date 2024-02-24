import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/core/utils/size_config.dart';
import 'package:balagh/features/users/widgets/comments.dart';
import 'package:balagh/features/users/widgets/new_comment.dart';
import 'package:balagh/features/users/widgets/report_big_card.dart';
import 'package:balagh/model/report.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReportCommentsView extends StatefulWidget {
  const ReportCommentsView({super.key, required this.report});

  final Report report;

  @override
  State<ReportCommentsView> createState() => _ReportCommentsViewState();
}

class _ReportCommentsViewState extends State<ReportCommentsView> {
  @override
  void initState() {
    super.initState();
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
            widget.report.type,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: kMidtBlue, fontWeight: FontWeight.bold, fontSize: 26),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ReportBigCard(report: widget.report),
              SizedBox(height: SizeConfig.defaultSize! * 3),
              Text(
                'Comments',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: kMidtBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 26),
              ),
              SizedBox(height: SizeConfig.defaultSize! * 2),
              SizedBox(
                height: SizeConfig.screenHeight! / 4,
                child: Comments(report: widget.report),
              ),
              NewComment(report: widget.report),
            ]),
          ),
        ));
  }
}
