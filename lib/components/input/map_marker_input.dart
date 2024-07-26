import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:oprs/constant_values.dart';

class MapMarkerInput extends StatefulWidget {
  LatLng initialPoint;
  final Function(TapPosition, LatLng) onMarkerChanged;
  MapMarkerInput({
    super.key,
    this.initialPoint = const LatLng(9.031189291103262, 38.752624277434705),
    required this.onMarkerChanged,
  });
  @override
  State<MapMarkerInput> createState() => _MapMarkerInputState();
}

class _MapMarkerInputState extends State<MapMarkerInput> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        onTap: (position, latLng) {
          setState(() {
            widget.initialPoint = latLng;
            widget.onMarkerChanged(position, latLng);
          });
        },
        initialCenter: widget.initialPoint,
        initialZoom: 18,
        interactionOptions: const InteractionOptions(
            flags: ~InteractiveFlag.pinchZoom |
                ~InteractiveFlag.pinchMove |
                ~InteractiveFlag.rotate),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          maxZoom: 30,
        ),
        MarkerLayer(
          markers: [
            Marker(
              height: 35,
              width: 35,
              alignment: Alignment.centerLeft,
              point: widget.initialPoint,
              child: const Icon(
                Icons.location_pin,
                color: MyColors.mainThemeDarkColor,
                size: 35,
              )
            )
          ]
        )
      ],
    );
  }
}