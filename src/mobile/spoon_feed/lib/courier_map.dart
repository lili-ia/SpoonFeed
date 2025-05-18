import 'dart:async';
import 'package:courier_app/models/geolocation_status.dart';
import 'package:courier_app/models/order.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class CourierMap extends StatefulWidget {
  const CourierMap({
    super.key,
    required this.order,
    required this.updateState,
    required this.showAlertDialog,
    required this.geolocationStatus,
  });
  final GeolocationStatus geolocationStatus;
  final Order order;
  final Function(
    LatLng courierPosition,
    List<double> restaurantDistance,
    double customerDistance,
  )
  updateState;
  final Function(String text) showAlertDialog;
  final String _mapStyle = '''
[
  {
    "featureType": "poi.business",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "poi.attraction",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "poi.place_of_worship",
    "stylers": [{ "visibility": "off" }]
  },
  {
    "featureType": "poi.school",
    "stylers": [{ "visibility": "off" }]
  }
]
''';
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
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    updateState();
  }

  void createPolylinePoints(List<LatLng> points) {
    polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: points,
        color: Colors.deepOrange,
        width: 5,
      ),
    );
  }

  Future<List<LatLng>?> getRoutePoints(LatLng destination) async {
    final String apiKey =
        "5b3ce3597851110001cf62486b6e661874304d439f6f71f922f53baf";
    OpenRouteService openrouteservice = OpenRouteService(apiKey: apiKey);
    try {
      final coordinates = await openrouteservice.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        ),
        endCoordinate: ORSCoordinate(
          latitude: destination.latitude,
          longitude: destination.longitude,
        ),
      );
      return coordinates.map((point) {
        return LatLng(point.latitude, point.longitude);
      }).toList();
    } catch (e) {
      return null;
    }
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

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void createMarkers() {
    if (markers.isEmpty) {
      for (var i = 0; i < widget.order.restaurants!.length; i++) {
        markers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: widget.order.restaurants![i].position,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              widget.getColor(widget.order.restaurants![i].color!),
            ),
          ),
        );
      }
      markers.add(
        Marker(
          markerId: MarkerId("customer"),
          position: widget.order.customer!.position,
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
      Position? position;
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
        _currentPosition = LatLng(position!.latitude, position.longitude);
      });

      if (!widget.order.active) {
        isRunning = false;
        return;
      }
      List<double> distancesToRestaurants = [];
      for (var i = 0; i < widget.order.restaurants!.length; i++) {
        distancesToRestaurants.add(
          Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            widget.order.restaurants![i].position.latitude,
            widget.order.restaurants![i].position.longitude,
          ),
        );
      }
      setState(() {
        if (markers.isEmpty) {
          createMarkers();
        }
        widget.updateState(
          _currentPosition!,
          distancesToRestaurants,
          Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            widget.order.customer!.position.latitude,
            widget.order.customer!.position.longitude,
          ),
        );
      });
      final points = await getRoutePoints(
        widget.order.needToDeliver()!.position,
      );
      setState(() {
        if (points != null) {
          createPolylinePoints(points);
        }
      });
      isRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _currentPosition == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
          style: widget._mapStyle,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: _currentPosition!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
          markers: markers,
          polylines: polylines,
        );
  }
}
