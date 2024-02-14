import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:reco/directions_repostory.dart';
import 'package:reco/model/classifier.dart';
import 'package:reco/model/directions_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reco/model/re_point.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.stream});

  final Stream<int> stream;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const CameraPosition _initialCameraPosition =
      CameraPosition(target: LatLng(39.92077, 32.85405), zoom: 15.5);

  final Completer<GoogleMapController> _controller = Completer();
  Marker? _origin = const Marker(markerId: MarkerId('origin'));
  Marker? _destination = const Marker(markerId: MarkerId('destination'));
  Directions? _info;

  @override
  void initState() {
    widget.stream.listen((event) {
      setState(() {});
    });

    packdata();
    super.initState();
  }

  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error$error');
    });

    return await Geolocator.getCurrentPosition();
  }

  packdata() {
    getUserLocation().then((value) async {
      print("My location");
      print("${value.latitude} ${value.longitude}");

      _origin = Marker(
          markerId: const MarkerId('Second'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(
            title: 'My location',
          ));

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 15);

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('re_points').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const LinearProgressIndicator();

              List<RePoint> points = snapshot.data!.docs.map((data) => RePoint.fromSnapshot(data)).toList();
              if (Classifier.lastScanned != null) {
                points = points.where((point) => point.name == Classifier.lastScanned!).toList();
              }

              List<Marker> markers = points.map((RePoint point) => Marker(
                  markerId: MarkerId(point.name),
                  position: LatLng(point.lat, point.lon),
                  infoWindow: InfoWindow(title: point.name),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  onTap: () async {
                    final directions = await DirectionsRepository()
                        .getDirections(origin: _origin!.position, destination: LatLng(point.lat, point.lon));
                    setState(() => _info = directions);
                  }
              )).toList();

              if (_origin != null) markers.add(_origin!);

              return GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (controller) => _controller.complete(controller),
                markers: markers.toSet(),
                polylines: {
                  if (_info != null)
                    Polyline(
                      polylineId: const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: _info!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                },
                // onLongPress: _addDestinationMarker,
              );
            }
          ),

          if (_info != null)
            Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info?.totalDistance}, ${_info?.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ))
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,50),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff538f47),
          foregroundColor: const Color(0xfff1f1f1),
          onPressed: () {
            packdata();
          },
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('My Location'),
        infoWindow: const InfoWindow(title: 'My Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: pos,
      );
    });
  }

  void _addDestinationMarker(LatLng pos) async {
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: pos,
      );
      //_destination = null;
    });
    // Get directions
    final directions = await DirectionsRepository()
        .getDirections(origin: _origin!.position, destination: pos);
    setState(() => _info = directions);
  }
}
