import 'package:flutter/material.dart';
import 'package:spoonfeed_customer/models/order.dart';
import 'package:flutter_map/flutter_map.dart';

class CustomerMap extends StatefulWidget {
  const CustomerMap({super.key, required this.activeOrder});
  final Order activeOrder;

  @override
  State<StatefulWidget> createState() {
    return _CustomerMapState();
  }
}

class _CustomerMapState extends State<CustomerMap> {
  late List<Marker> markers = [];
  final List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
  ];
  @override
  Widget build(BuildContext context) {
    markers = [];
    for (var restaurant in widget.activeOrder.restaurants) {
      markers.add(
        Marker(
          point: restaurant.position,
          child: Icon(Icons.location_pin, size: 42, color: restaurant.color),
        ),
      );
    }
    markers.add(
      Marker(
        point: widget.activeOrder.courier.position,
        child: Icon(Icons.location_pin, color: Colors.red, size: 42),
      ),
    );
    markers.add(
      Marker(
        point: widget.activeOrder.customer.position,
        child: Icon(Icons.location_pin, color: Colors.black, size: 42),
      ),
    );
    return SizedBox(
      height: 400,
      child: FlutterMap(
        options: MapOptions(
          initialZoom: 16,
          initialCenter: widget.activeOrder.customer.position,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }
}
