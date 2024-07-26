import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:oprs/constant_values.dart';

class MapLocationView extends StatelessWidget {
  final LatLng latLng;
  const MapLocationView({super.key, required this.latLng});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
            initialCenter: latLng,
            initialZoom: 18,
            interactionOptions: const InteractionOptions(
              flags : ~InteractiveFlag.pinchZoom |
                      ~InteractiveFlag.pinchMove |
                      ~InteractiveFlag.rotate,
            )
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
                    point: latLng,
                    child: const Icon(
                      Icons.location_pin,
                      color: MyColors. mainThemeDarkColor,
                      size: 35,
                    )
                )
              ]
          )
        ],
      );
  }
}
