import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CourierMap extends StatefulWidget {
  const CourierMap({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CourierMapState();
  }
}

Future<Position?> getCurrentPosition() async {
  try {
    print("Checking permission...");
    LocationPermission locationPermission = await Geolocator.checkPermission();
    print("Initial permission: $locationPermission");

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      print("Requested permission: $locationPermission");

      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        throw Exception("Permission denied");
      }
    }

    final position = await Geolocator.getCurrentPosition();
    print("Position: $position");
    return position;
  } catch (e, stack) {
    print("Geolocation error: $e");
    print("Stack trace: $stack");
    return null;
  }
}

class _CourierMapState extends State<CourierMap> {
  GoogleMapController? _googleMapController;
  LatLng? _currentPosition;
  Marker? _courierMarker;
  @override
  void initState() {
    super.initState();
    loadMap();
  }

  void loadMap() async {
    final position = await getCurrentPosition();
    if (position == null) {
      print("error");
      return;
    }
    setState(() {
      _currentPosition = LatLng(position!.latitude, position.longitude);
      _courierMarker = Marker(markerId: MarkerId("courier"));
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ? Text("Loading")
        : GoogleMap(
          initialCameraPosition: CameraPosition(target: _currentPosition!),
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
          markers: {_courierMarker!},
        );
  }
}
