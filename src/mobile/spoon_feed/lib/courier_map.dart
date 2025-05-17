import 'dart:async';
import 'package:courier_app/models/geolocation_status.dart';
import 'package:courier_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CourierMap extends StatefulWidget {
  const CourierMap({
    super.key,
    required this.activeOrder,
    required this.updateState,
    required this.showAlertDialog,
    required this.geolocationStatus,
  });
  final GeolocationStatus geolocationStatus;
  final Order activeOrder;
  final Function(
    LatLng courierPosition,
    List<double> restaurantDistance,
    double customerDistance,
  )
  updateState;
  final Function(String text) showAlertDialog;
  @override
  State<StatefulWidget> createState() {
    return _CourierMapState();
  }
}

class _CourierMapState extends State<CourierMap> {
  GoogleMapController? _googleMapController;
  LatLng? _currentPosition;
  Timer? timer;
  Set<Marker> markers = {};
  bool geolocatorPermissionError = false;
  bool geolocatorEnabledError = false;
  @override
  void initState() {
    super.initState();
    updateState();
  }

  Future<Position?> getCurrentPosition() async {
    print("Checking permission...");
    LocationPermission locationPermission = await Geolocator.checkPermission();
    print("Initial permission: $locationPermission");

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      locationPermission = await Geolocator.requestPermission();
      print("Requested permission: $locationPermission");

      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        throw PermissionDeniedException("Permission denied");
      } else {
        widget.geolocationStatus.locationPermission = true;
        geolocatorPermissionError = false;
      }
    } else {
      widget.geolocationStatus.locationPermission = true;
      geolocatorPermissionError = false;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw LocationServiceDisabledException();
    } else {
      widget.geolocationStatus.isLocationServiceEnable = true;
      geolocatorEnabledError = false;
    }
    final position = await Geolocator.getCurrentPosition();

    print("Position: $position");
    return position;
  }

  double getColor(Color color) {
    switch (color) {
      case Colors.orange:
        return BitmapDescriptor.hueOrange;
      case Colors.blue:
        return BitmapDescriptor.hueBlue;
      case Colors.green:
        return BitmapDescriptor.hueGreen;
      case Colors.red:
        return BitmapDescriptor.hueRed;
    }
    return -1;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void createMarkers() {
    if (markers.isEmpty) {
      for (var i = 0; i < widget.activeOrder.restaurants!.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: widget.activeOrder.restaurants![i].position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              getColor(widget.activeOrder.restaurants![i].color!),
            ),
          ),
        );
      }
      markers.add(
        Marker(
          markerId: MarkerId("customer"),
          position: widget.activeOrder.customer!.position,
        ),
      );
    }
  }

  bool isRunning = false;
  void updateState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (isRunning) {
        return;
      }
      isRunning = true;
      var position;
      try {
        position = await getCurrentPosition();
      } on PermissionDeniedException {
        if (!geolocatorPermissionError) {
          geolocatorPermissionError = true;

          widget.showAlertDialog("Without geodata permission you can't work");
        }
        widget.geolocationStatus.locationPermission = false;
        isRunning = false;
        return;
      } on LocationServiceDisabledException {
        if (!geolocatorEnabledError) {
          try {
            position = await Geolocator.getCurrentPosition();
            widget.geolocationStatus.isLocationServiceEnable = true;
            geolocatorEnabledError = false;
          } catch (e) {
            print(e);
          }
        }
        if (position == null && !geolocatorEnabledError) {
          geolocatorEnabledError = true;

          widget.showAlertDialog(
            "Your location data is turned off. Turn on location data to continue working",
          );

          widget.geolocationStatus.isLocationServiceEnable = false;
        }
        isRunning = false;
        return;
      }

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);

        if (widget.activeOrder.active) {
          createMarkers();
          List<double> distancesToRestaurants = [];
          for (var i = 0; i < widget.activeOrder.restaurants!.length; i++) {
            distancesToRestaurants.add(
              Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                widget.activeOrder.restaurants![i].position.latitude,
                widget.activeOrder.restaurants![i].position.longitude,
              ),
            );
          }
          widget.updateState(
            _currentPosition!,
            distancesToRestaurants,
            Geolocator.distanceBetween(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
              widget.activeOrder.customer!.position.latitude,
              widget.activeOrder.customer!.position.longitude,
            ),
          );
        } else {
          markers = {};
        }
        isRunning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
          markers: markers,
        );
  }
}
