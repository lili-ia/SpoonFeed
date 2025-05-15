import 'package:flutter/material.dart';

class VehicleType {
  final String _value;
  final IconData _icon;

  const VehicleType(this._value, this._icon);
  String get value => _value;
  IconData get icon => _icon;
}
