import 'dart:async';

import 'package:courier_app/models/active_order.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CourierMap extends StatefulWidget {
  const CourierMap({
    super.key,
    required this.activeOrder,
    required this.updateState,
  });
  final ActiveOrder activeOrder;
  final Function(
    LatLng courierPosition,
    List<String> restaurantDistance,
    String customerDistance,
  )
  updateState;
  @override
  State<StatefulWidget> createState() {
    return _CourierMapState();
  }
}

Future<Position?> getCurrentPosition() async {
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
}

class _CourierMapState extends State<CourierMap> {
  GoogleMapController? _googleMapController;
  LatLng? _currentPosition;
  Timer? timer;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    updateState();
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

  void updateState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final position = await getCurrentPosition();
      if (position == null) {
        print("error");
        return;
      }
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);

        if (widget.activeOrder.active) {
          createMarkers();
          List<String> distancesToRestaurants = [];
          for (var i = 0; i < widget.activeOrder.restaurants!.length; i++) {
            var distToRestaurant =
                Geolocator.distanceBetween(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                  widget.activeOrder.restaurants![i].position.latitude,
                  widget.activeOrder.restaurants![i].position.longitude,
                ).toString();
            distancesToRestaurants.add(distToRestaurant);
          }
          var distToCustomer =
              Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                widget.activeOrder.customer!.position.latitude,
                widget.activeOrder.customer!.position.longitude,
              ).toString();
          setState(() {
            widget.updateState(
              _currentPosition!,
              distancesToRestaurants,
              distToCustomer,
            );
          });
        }
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
