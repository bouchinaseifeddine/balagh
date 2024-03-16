import 'package:geolocator/geolocator.dart';

class ReportLocation {
  const ReportLocation({
    required this.latitude,
    required this.longitude,
    required this.adress,
  });
  final double latitude;
  final double longitude;
  final String adress;

  // Calculate the  distance between City Center  and The Report Location
  String get getDistance {
    var distance = Geolocator.distanceBetween(
        36.899663356020184, 7.760038655859154, latitude, longitude);

    return (distance / 1000).toString();
  }
}
