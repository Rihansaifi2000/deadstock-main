import 'dart:convert';
import 'package:deadstock/Screens/detail_screen.dart';
import 'package:deadstock/Screens/map_screen.dart';
import 'package:deadstock/Screens/product_screen.dart';
import 'package:deadstock/Screens/search_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as https;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _currentAddress;
  Position? _currentPosition;
  int activeIndex = 0;
  bool isActive = false;
  Map HomeDetails = {};
  List returnData = [];
  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    setState(() {
      isActive = true;
    });
  }

  var Lat = "";
  var Long = "";
  final urlImages = [
    "https://deadstock.webkype.co/public/banner/6336e51e902a0_Homepage2.jpeg",
    "https://deadstock.webkype.co/public/banner/6336d41145a44_Homepage3.jpg",
    "https://deadstock.webkype.co/public/banner/6336e51e902a0_Homepage2.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0x80bc322d),
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            "Home",
            style: GoogleFonts.dmSans(
                color: const Color(0xffffffff),
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SearchScreen(
                      Lat: Lat,
                      Long: Long,
                    );
                  }));
                },
                icon: Image.asset(
                  "assets/icons/search.png",
                  width: 23,
                  color: const Color(0xffffffff),
                )),
          ]),
      body: (isActive)
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xffbc322d),
                strokeWidth: 1.5,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      color: Color(0x80bc322d),
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
                          HomeDetailApi(returnData[1], returnData[2]);
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
                        ]),
                      ),
                    ),
                    Stack(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 200,
                        color: Colors.white,
                        child: CarouselSlider.builder(
                          itemCount: HomeDetails["sliders"].length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage =
                                HomeDetails["sliders"][index]["image"];
                            final ID = HomeDetails["sliders"][index]
                                    ["category_id"]
                                .toString();
                            final Text = HomeDetails["sliders"][index]
                                    ["category_name"]
                                .toString();
                            return buildImage(urlImage, index, ID, Text);
                          },
                          options: CarouselOptions(
                            height: 200,
                            initialPage: 0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            viewportFraction: 1.04,
                            onPageChanged: (index, reason) => setState(() {
                              activeIndex = index;
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 20,
                          left: MediaQuery.of(context).size.width / 2.35,
                          child: buildIndicator(HomeDetails["sliders"].length))
                    ]),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Today's Deals",
                        style: GoogleFonts.dmSans(
                            color: const Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 230,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: HomeDetails["deals"].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailScreen(
                                    Id: HomeDetails["deals"][index]["id"]
                                        .toString(),
                                  );
                                }));
                              },
                              child: Card(
                                margin: const EdgeInsets.only(
                                  left: 7,
                                  right: 5,
                                ),
                                elevation: 0,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.35,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.35,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://deadstock.webkype.co/public/ad/${HomeDetails["deals"][index]["logo"]}"),
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Text(
                                            HomeDetails["deals"][index]
                                                ["title"],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              bottom: 5,
                                              top: 5),
                                          child: Text(
                                            "₹ ${HomeDetails["deals"][index]["price"]}",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff221f1f),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://deadstock.webkype.co/public/banner/${HomeDetails["banners"][0]["banner"]}"),
                              fit: BoxFit.fitWidth)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Featured Deals",
                        style: GoogleFonts.dmSans(
                            color: const Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 230,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: HomeDetails["features"].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailScreen(
                                    Id: HomeDetails["features"][index]["id"]
                                        .toString(),
                                  );
                                }));
                              },
                              child: Card(
                                margin: const EdgeInsets.only(
                                  left: 7,
                                  right: 5,
                                ),
                                elevation: 0,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.35,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.35,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://deadstock.webkype.co/public/ad/${HomeDetails["features"][index]["logo"]}"),
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Text(
                                            HomeDetails["features"][index]
                                                ["title"],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              bottom: 5,
                                              top: 5),
                                          child: Text(
                                            "₹ ${HomeDetails["features"][index]["price"]}",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff221f1f),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      margin:
                          const EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://deadstock.webkype.co/public/banner/${HomeDetails["banners"][1]["banner"]}"),
                              fit: BoxFit.fitWidth)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Collection",
                        style: GoogleFonts.dmSans(
                            color: const Color(0xff000000),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      height: 230,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: HomeDetails["collections"].length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailScreen(
                                    Id: HomeDetails["collections"][index]["id"]
                                        .toString(),
                                  );
                                }));
                              },
                              child: Card(
                                margin: const EdgeInsets.only(
                                  left: 7,
                                  right: 5,
                                ),
                                elevation: 0,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.35,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.35,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://deadstock.webkype.co/public/ad/${HomeDetails["collections"][index]["logo"]}"),
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, top: 5),
                                          child: Text(
                                            HomeDetails["collections"][index]
                                                ["title"],
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff000000),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              bottom: 5,
                                              top: 5),
                                          child: Text(
                                            "₹ ${HomeDetails["collections"][index]["price"]}",
                                            style: GoogleFonts.dmSans(
                                              fontSize: 14,
                                              color: const Color(0xff221f1f),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }),
                    ),
                  ]),
            ),
    );
  }

  ///Image Builder
  Widget buildImage(String urlImage, int index, String ID, String Text) =>
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProductScreen(
              text: Text,
              Id: ID,
            );
          }));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            image: DecorationImage(
              image: NetworkImage(
                  "https://deadstock.webkype.co/public/image/${urlImage}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );

  ///Indicator Builder
  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: count,
        effect: const ColorTransitionEffect(
          dotHeight: 10,
          dotWidth: 10,
          dotColor: Color(0xffd0d0d0),
          activeDotColor: Color(0xffbc322d),
        ),
      );

  Future HomeDetailApi(String lat, long) async {
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/homepanel"),
        body: {"latitude": lat, "longitude": long});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          HomeDetails = data["data"];
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
      HomeDetailApi(
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
