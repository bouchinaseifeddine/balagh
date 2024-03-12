import 'package:balagh/model/report_location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

final stateIcons = {
  'pending': Ionicons.hourglass,
  'reported': Icons.miscellaneous_services_outlined,
  'fixed': Icons.done_all,
};

class Report {
  final String reportId;
  final String userId;
  final String description;
  final ReportLocation? location;
  final DateTime? dateOfReporting;
  final DateTime? dateOfFixing;
  var type;
  final String firstImage;
  final String secondImage;
  var currentState;
  final bool isUrgent;

  Report({
    required this.reportId,
    required this.userId,
    required this.description,
    this.location,
    this.dateOfReporting,
    this.dateOfFixing,
    required this.type,
    required this.firstImage,
    required this.secondImage,
    required this.isUrgent,
    required this.currentState,
  });

  // get the date formatted
  String get formattedDateOfReporting {
    return DateFormat.yMMMMEEEEd().format(dateOfReporting!);
  }

  String get formattedDateOfFixing {
    return DateFormat.yMMMMEEEEd().format(dateOfFixing!);
  }

  String shortFormattedDate(dateString) {
    DateTime dateTime = DateFormat("EEEE, MMMM d, yyyy").parse(dateString);

    // Format the DateTime object to display only the month and day
    String trimmedDate = DateFormat("MMM dd").format(dateTime);
    return trimmedDate;
  }
}
