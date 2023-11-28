import 'dart:async';
import 'dart:convert';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final String apiKey = 'AIzaSyAUA0Tr4oFc_BNL9DEeVWayBDUcd2GeYxw';
  final Set<Marker> _markers = {};
  List returnData = [];
  var _currentAddress = "";
  var lat = "";
  var long = "";
  final TextEditingController searchController = TextEditingController();
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex =
  CameraPosition(target: LatLng(21.7679, 78.8718), zoom: 2.5);
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xff3167af),
          elevation: 0,
          leadingWidth: 40,
          title: Text(
            "Location",
            style: GoogleFonts.inter(
              color: const Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Stack(children: [
        Column(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            child: GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              initialCameraPosition: _kGooglePlex,
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: (latlang) async {
                if (_markers.length >= 1) {
                  _markers.clear();
                }
                lat = latlang.latitude.toString();
                long = latlang.longitude.toString();
                await placemarkFromCoordinates(
                    latlang.latitude, latlang.longitude)
                    .then((List<Placemark> placemarks) {
                  Placemark place = placemarks[0];
                  setState(() {
                    _currentAddress =
                    '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
                  });
                }).catchError((e) {
                  debugPrint(e);
                });
                _onAddMarkerButtonPressed(latlang);
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Your Location",
            style: GoogleFonts.dmSans(
              color: const Color(0xff7c7c7c),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(
            height: 20,
            thickness: 2,
            indent: 10,
            endIndent: 10,
            color: Color(0xffdadada),
          ),
          Text(
            _currentAddress,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: const Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            "Lat:${lat}  Long:${long}",
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: const Color(0xff000000),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: GestureDetector(
              onTap: () {
                returnData = [_currentAddress, lat, long];
                Navigator.of(context).pop(returnData);
              },
              child: ButtonWidget(
                width: MediaQuery.of(context).size.width / 1.5,
                text: 'Use This Location',
                textColor: Colors.white,
                color: const Color(0xff3167AF),
              ),
            ),
          )
        ]),
        Positioned(
          top: 10,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.1,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 15,right: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search for a place',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: _searchPlace,
                    ),
                  ),
                  onSubmitted: (_) {
                    _searchPlace();
                  },
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: MediaQuery.of(context).size.height / 4,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 0,
            onPressed: () {
              getLatLong();
            },
            child: const Icon(
              Icons.my_location,
              color: Color(0xff3167af),
            ),
          ),
        ),
      ]),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
  }

  getLatLong() async {
    final GoogleMapController controller = await _controller.future;
    Future<Position> data = _determinePosition();
    data.then((value) {
      setState(() {
        lat = value.latitude.toString();
        long = value.longitude.toString();
        _getAddressFromLatLng(value);
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(""),
          position: LatLng(value.latitude, value.longitude),
          icon: BitmapDescriptor.defaultMarker,
        ));
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 19,
          ),
        ));
      });
    }).catchError((error) {
      print("Error $error");
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(""),
        position: latlang,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Future<void> _searchPlace() async {
    final GoogleMapController controller = await _controller.future;
    final String input = searchController.text;
    final String baseUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json';
    final String location =
        '37.7749,-122.4194'; // Default location (San Francisco)
    final String radius = '10000'; // Search radius in meters (adjust as needed)

    final Uri uri = Uri.parse(
      '$baseUrl?query=$input&location=$location&radius=$radius&key=$apiKey',
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final predictions = data['results'] as List<dynamic>;
      setState(() {
        _currentAddress = predictions[0]["formatted_address"];
        lat = predictions[0]["geometry"]["location"]["lat"].toString();
        long = predictions[0]["geometry"]["location"]["lng"].toString();
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(predictions[0]["geometry"]["location"]["lat"],
              predictions[0]["geometry"]["location"]["lng"]),
          zoom: 19,
        )));
        _markers.add(Marker(
          markerId: MarkerId(""),
          position: LatLng(predictions[0]["geometry"]["location"]["lat"],
              predictions[0]["geometry"]["location"]["lng"]),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    } else {
      throw Exception('Failed to load place data');
    }
  }
}
