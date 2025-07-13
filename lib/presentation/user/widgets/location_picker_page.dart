import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng? _pickedLocation;
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Lokasi'),
        backgroundColor: Colors.brown,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.200000, 106.816666), // Jakarta by default
              zoom: 5,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (position) {
              setState(() {
                _pickedLocation = position;
              });
            },
            markers: _pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _pickedLocation!,
                    ),
                  }
                : {},
          ),
          if (_pickedLocation != null)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _pickedLocation);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Gunakan Lokasi Ini'),
              ),
            ),
        ],
      ),
    );
  }
}
