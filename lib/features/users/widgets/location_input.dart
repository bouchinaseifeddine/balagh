import 'dart:convert';

import 'package:balagh/core/constants/constants.dart';
import 'package:balagh/model/report_location.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSetLocation});

  final Function onSetLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  ReportLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=18&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCdIq65pwy2KoNBa42AhnecTG3wZN5j4EQ';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCdIq65pwy2KoNBa42AhnecTG3wZN5j4EQ');
    final response = await http.get(url);
    final resData = json.decode(response.body);
    final addressComponents = resData['results'][0]['address_components'];
    String adress;
    String? city;
    String? country;
    for (var component in addressComponents) {
      final types = component['types'];
      if (types.contains('locality')) {
        city = component['long_name'];
      } else if (types.contains('country')) {
        country = component['long_name'];
      }
    }
    adress = '$city, $country';

    setState(() {
      _pickedLocation = ReportLocation(
        latitude: lat,
        longitude: lng,
        adress: adress,
      );
      _isGettingLocation = false;
    });
    widget.onSetLocation(_pickedLocation);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text('No location chosen',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!);

    if (_pickedLocation != null) {
      previewContent = ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          locationImage,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator(color: kMidtBlue);
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: kWhite,
              border: Border.all(color: kDarkGrey.withOpacity(0.7), width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(24))),
          child: previewContent,
        ),
        TextButton.icon(
          icon: const Icon(
            Icons.location_on,
            color: kMidtBlue,
          ),
          label: Text(
            'Get Current Location',
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
          onPressed: _getCurrentLocation,
        ),
      ],
    );
  }
}
