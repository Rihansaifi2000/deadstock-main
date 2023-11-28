import 'dart:convert';
import 'dart:ui';
import 'package:deadstock/Widgets/button_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as https;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:deadstock/Screens/vendor_details_screen.dart';
import 'package:deadstock/Screens/write_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:star_rating/star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String Id;
  const DetailScreen({super.key, required this.Id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final TextEditingController offerController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  bool isActive = false;
  Map Details = {};
  int activeIndex = 0;
  int segmentedControlValue = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    DetailApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Product Detail",
            style: GoogleFonts.dmSans(
              color: Color(0xffffffff),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Color(0x80bc322d),
        leadingWidth: 35,
        automaticallyImplyLeading: false,
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
      ),
      body: (isActive)
          ? Center(
              child: CircularProgressIndicator(
                color: Color(0xffbc322d),
                strokeWidth: 1.5,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Stack(children: [
                      CarouselSlider.builder(
                        itemCount: Details["images"].length,
                        itemBuilder: (context, index, realIndex) {
                          final urlImage = Details["images"][index]["image"];
                          return buildImage(urlImage, index);
                        },
                        options: CarouselOptions(
                          height: 220,
                          initialPage: 0,
                          autoPlay: false,
                          autoPlayInterval: const Duration(seconds: 3),
                          viewportFraction: 0.8,
                          onPageChanged: (index, reason) => setState(() {
                            activeIndex = index;
                          }),
                        ),
                      ),
                      Positioned(
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              if (Details["wish_status"] == 0) {
                                ADDWishListApi();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Product already in wishlist",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.6),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50)),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  (Details["wish_status"] == 0)
                                      ? "assets/icons/heart.png"
                                      : "assets/icons/heart (1).png",
                                  color: (Details["wish_status"] == 0)
                                      ? Colors.black
                                      : Colors.pink.shade200,
                                  width: 25,
                                ),
                              ),
                            ),
                          ))
                    ]),
                    const SizedBox(
                      height: 10,
                    ),
                    buildIndicator(Details["images"].length),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Details["title"],
                              style: GoogleFonts.dmSans(
                                textStyle: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              Text(
                                "Seller:",
                                style: GoogleFonts.dmSans(
                                  textStyle: const TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return VendorDetailsScreen(
                                      Id: Details["user"]["id"].toString(),
                                    );
                                  }));
                                },
                                child: Row(children: [
                                  CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      radius: 18,
                                      backgroundImage: NetworkImage((Details[
                                                  "user"]["image"] ==
                                              null)
                                          ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                                          : "https://deadstock.webkype.co/public/user/${Details["user"]["image"]}")),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      "${Details["user"]["firstName"]} ${Details["user"]["lastName"]}",
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xff000000),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ]),
                              ),
                            ]),
                            SizedBox(
                              height: 5,
                            ),
                            Text("₹ ${Details["price"]}",
                                style: GoogleFonts.dmSans(
                                  color: const Color(0xffbc322d),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    var url = 'tel:${Details["user"]["phone"]}';
                                    await launchUrl(Uri.parse(url));
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xb2bc322d),
                                            Color(0xffbc322d),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/phone-call.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Call",
                                              style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<void>(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 0.2, sigmaY: 0.2),
                                            child: AlertDialog(
                                              backgroundColor: Colors.white,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              title: Text(
                                                "Drop Us A Line",
                                                style: GoogleFonts.dmSans(
                                                  color: Color(0xff000000),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade400,
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Color(0xffbc322d),
                                                        controller:
                                                            offerController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          border:
                                                              InputBorder.none,
                                                          hintText:
                                                              "Your offer",
                                                          hintStyle: GoogleFonts
                                                              .dmSans(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400),
                                                        ),
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          top: 10),
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade400,
                                                            width: 1.5),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child: TextField(
                                                        cursorColor:
                                                            Color(0xffbc322d),
                                                        controller:
                                                            messageController,
                                                        keyboardType:
                                                            TextInputType.text,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        maxLines: 5,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10),
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Message",
                                                          hintStyle: GoogleFonts
                                                              .dmSans(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey
                                                                      .shade400),
                                                        ),
                                                        style:
                                                            GoogleFonts.dmSans(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 30,
                                                              left: 10,
                                                              right: 10),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await SendOfferApi();
                                                          offerController
                                                              .clear();
                                                          messageController
                                                              .clear();
                                                        },
                                                        child: ButtonWidget(
                                                          text: "Send",
                                                          color:
                                                              Color(0xffbc322d),
                                                          textColor:
                                                              Colors.white,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
                                            ),
                                          );
                                        });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xffbc322d),
                                            Color(0xb2bc322d),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/email.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Send Offer",
                                              style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    var url =
                                        'https://wa.me/+91${Details["user"]["phone"]}}';
                                    await launchUrl(Uri.parse(url),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xff25d366),
                                            Color(0xb225d366),
                                          ],
                                        ),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/whatsapp.png",
                                              color: Colors.white,
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Whatsapp",
                                              style: GoogleFonts.dmSans(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ])),
                                ),
                              )
                            ])
                          ]),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: segmentedControlValue,
                        backgroundColor: Color(0x1abc322d),
                        children: {
                          0: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'DESCRIPTION',
                              style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: (segmentedControlValue == 0)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          1: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'REVIEWS',
                              style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: (segmentedControlValue == 1)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                          2: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'SELLER REVIEWS',
                              style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: (segmentedControlValue == 2)
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        },
                        thumbColor: Color(0xc0bc322d),
                        onValueChanged: (i) {
                          setState(() {
                            segmentedControlValue = i!;
                          });
                        },
                      ),
                    ),
                    details(),
                  ]),
            ),
    );
  }

  Widget details() {
    if (segmentedControlValue == 0) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: double.infinity,
          ),
          Text(
            Details["description"],
            style: GoogleFonts.dmSans(
              textStyle: const TextStyle(
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ]),
      );
    } else if (segmentedControlValue == 1) {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Customer Reviews",
              style: GoogleFonts.dmSans(
                color: const Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WriteReview(
                  ID: widget.Id,
                  Type: 'Product',
                );
              })).whenComplete(() => DetailApi());
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Color(0xc0bc322d),
                  size: 20,
                ),
                SizedBox(
                  width: 3,
                ),
                Text("Write a review",
                    style: GoogleFonts.dmSans(
                      color: Color(0xc0bc322d),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          )
        ]),
        (Details["ad_review"].isNotEmpty)
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Details["ad_review"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage((Details["ad_review"]
                                    [index]["user_logo"] ==
                                null)
                            ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                            : "https://deadstock.webkype.co/public/user/${Details["ad_review"][index]["user_logo"]}")),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StarRating(
                            color: Color(0xc0bc322d),
                            mainAxisAlignment: MainAxisAlignment.start,
                            length: 5,
                            rating: double.parse(Details["ad_review"][index]
                                    ["rating"]
                                .toString()),
                            between: 5,
                            starSize: 20,
                            onRaitingTap: (rating) {},
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${Details["ad_review"][index]["name"]} on ${DateFormat('dd MMM y').format(DateTime.parse(Details["ad_review"][index]["created_at"]))}",
                            style: GoogleFonts.dmSans(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ]),
                    subtitle: Text(
                      Details["ad_review"][index]["review"],
                      style: GoogleFonts.dmSans(
                        color: const Color(0xff000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.black45,
                    indent: 15,
                    endIndent: 15,
                  );
                },
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8),
                child: Text("Nothing to show",
                    style: GoogleFonts.dmSans(
                      color: const Color(0xff535353),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )))
      ]);
    } else {
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Customer Reviews",
              style: GoogleFonts.dmSans(
                color: const Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return WriteReview(
                  ID: Details["user"]["id"],
                  Type: 'User',
                );
              })).whenComplete(() => DetailApi());
            },
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Color(0xc0bc322d),
                  size: 20,
                ),
                SizedBox(
                  width: 3,
                ),
                Text("Write a review",
                    style: GoogleFonts.dmSans(
                      color: Color(0xc0bc322d),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          )
        ]),
        (Details["seller_review"].isNotEmpty)
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Details["seller_review"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage((Details["seller_review"]
                                    [index]["user_logo"] ==
                                null)
                            ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                            : "https://deadstock.webkype.co/public/user/${Details["seller_review"][index]["user_logo"]}")),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StarRating(
                            color: Color(0xc0bc322d),
                            mainAxisAlignment: MainAxisAlignment.start,
                            length: 5,
                            rating: double.parse(Details["seller_review"][index]
                                    ["rating"]
                                .toString()),
                            between: 5,
                            starSize: 20,
                            onRaitingTap: (rating) {},
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${Details["seller_review"][index]["name"]} on ${DateFormat('dd MMM y').format(DateTime.parse(Details["seller_review"][index]["created_at"]))}",
                            style: GoogleFonts.dmSans(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ]),
                    subtitle: Text(
                      Details["seller_review"][index]["review"],
                      style: GoogleFonts.dmSans(
                        color: const Color(0xff000000),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.black45,
                    indent: 15,
                    endIndent: 15,
                  );
                },
              )
            : Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 8),
                child: Text("Nothing to show",
                    style: GoogleFonts.dmSans(
                      color: const Color(0xff535353),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )))
      ]);
    }
  }

  ///Image Builder
  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://deadstock.webkype.co/public/ad/${urlImage}"),
            fit: BoxFit.fitWidth,
          ),
        ),
      );

  ///Indicator Builder
  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: count,
        effect: const ColorTransitionEffect(
          dotHeight: 8,
          dotWidth: 8,
          dotColor: Color(0xffd0d0d0),
          activeDotColor: Color(0xc0bc322d),
        ),
      );

  Future DetailApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse(
            "https://deadstock.webkype.co/api/product_detail/${widget.Id}"),
        body: {
          "user_id": UID,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          Details = data["product"];
          isActive = false;
        });
      }
    }
  }

  Future<void> ADDWishListApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/addtowish/${UID}"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "ad_id": widget.Id,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        await DetailApi();
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: data["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.6),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future<void> SendOfferApi() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.post(
        Uri.parse("https://deadstock.webkype.co/api/send_Offer/${UID}"),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "ad_id": widget.Id,
          "offer": offerController.text,
          "message": messageController.text,
        });
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: data["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black.withOpacity(0.6),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      final data = json.decode(response.body);
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: data["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black.withOpacity(0.6),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
