import 'dart:convert';
import 'package:deadstock/Screens/map_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductScreen extends StatefulWidget {
  final String text;
  final String Id;
  const ProductScreen({super.key, required this.text, required this.Id});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var Lat = "";
  var Long = "";
  var Distance = "5";
  var distance = ["5", "10", "20", "50", "75", "100"];
  String? _currentAddress;
  Position? _currentPosition;
  bool isActive = false;
  List returnData = [];
  List ProductList = [];
  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    setState(() {
      isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text(widget.text,
              style: GoogleFonts.dmSans(
                color: Color(0xffffffff),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          backgroundColor: Color(0x80bc322d),
          automaticallyImplyLeading: false,
          leadingWidth: 35,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Color(0xffffffff),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(45),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: GestureDetector(
                onTap: () async {
                  returnData = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return MapScreen();
                  }));
                  setState(() {
                    _currentAddress = returnData[0];
                    Lat = returnData[1];
                    Long = returnData[2];
                  });
                  ProductListApi(returnData[1], returnData[2]);
                },
                child: Row(children: [
                  Icon(
                    Icons.my_location,
                    color: Colors.white,
                    size: 23,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(_currentAddress ?? "",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 115,
                    height: 45,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          dropdownColor: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          value: Distance,
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                            color: Colors.white,
                          ),
                          hint: Text(
                            "Select",
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          elevation: 0,
                          underline: Container(height: 1, color: Colors.white),
                          onChanged: (String? newValue) {
                            setState(() {
                              Distance = newValue!;
                            });
                            ProductListApi(Lat, Long);
                          },
                          items: distance
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                "${value} Miles",
                                style: GoogleFonts.dmSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
        body: (isActive)
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xffbc322d),
                  strokeWidth: 1.5,
                ),
              )
            : (ProductList.isNotEmpty)
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                        itemCount: ProductList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailScreen(
                                  Id: ProductList[index]["id"].toString(),
                                );
                              }));
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 7.5, bottom: 7.5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(children: [
                                Row(children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 15),
                                    height: 100,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://deadstock.webkype.co/public/ad/${ProductList[index]["logo"]}"),
                                            fit: BoxFit.fitWidth)),
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("${ProductList[index]["title"]}",
                                              style: GoogleFonts.dmSans(
                                                color: Color(0xff000000),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "₹ ${ProductList[index]["price"]}",
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          Text(
                                              "${ProductList[index]["description"]}",
                                              maxLines: 3,
                                              style: GoogleFonts.dmSans(
                                                color: const Color(0xff535353),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ]),
                                  ),
                                ]),
                              ]),
                            ),
                          );
                        }),
                  )
                : Center(
                    child: Text("Nothing to show",
                        style: GoogleFonts.dmSans(
                          color: const Color(0xff535353),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ));
  }

  Future ProductListApi(String lat, long) async {
    var response = await https
        .post(Uri.parse("http://deadstock.webkype.co/api/product_list"), body: {
      "cat": widget.Id,
      "latitude": lat,
      "longitude": long,
      "radious": Distance
    });
    print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          ProductList = data["servises"];
          isActive = false;
        });
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      _getCurrentPosition();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        Lat = _currentPosition!.latitude.toString();
        Long = _currentPosition!.longitude.toString();
      });
      ProductListApi(
        _currentPosition!.latitude.toString(),
        _currentPosition!.longitude.toString(),
      );
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
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
}
