import 'dart:convert';
import 'package:deadstock/Screens/detail_screen.dart';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/write_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:star_rating/star_rating.dart';

class VendorDetailsScreen extends StatefulWidget {
  final String Id;
  const VendorDetailsScreen({super.key, required this.Id});

  @override
  State<VendorDetailsScreen> createState() => _VendorDetailsScreenState();
}

class _VendorDetailsScreenState extends State<VendorDetailsScreen> {
  bool isActive = false;
  Map Details = {};
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x80bc322d),
        leadingWidth: 35,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xffffffff),
            ),
          ),
        ),
        title: Text(
          "Vendor Detail",
          style: GoogleFonts.dmSans(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w500,
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
              child: Column(children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                      top: 5, left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.grey.shade100],
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          radius: 46,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage((Details["image"] ==
                                    null)
                                ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                                : "https://deadstock.webkype.co/public/user/${Details["image"]}"),
                            backgroundColor: Colors.grey.shade200,
                            radius: 45,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text("${Details["firstName"]} ${Details["lastName"]}",
                            style: GoogleFonts.dmSans(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                        StarRating(
                          color: Color(0xc0bc322d),
                          mainAxisAlignment: MainAxisAlignment.center,
                          length: 5,
                          rating:
                              double.parse(Details["overAllRating"].toString()),
                          between: 0,
                          starSize: 20,
                          onRaitingTap: (rating) {},
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0x80bc322d),
                                    Color(0xcdbc322d),
                                  ],
                                ),
                              ),
                              child: Text(
                                "Follow",
                                style: GoogleFonts.dmSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xcdbc322d),
                                      Color(0x80bc322d),
                                    ],
                                  ),
                                ),
                                child: Text(
                                  "Like",
                                  style: GoogleFonts.dmSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ])
                      ]),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  width: MediaQuery.of(context).size.width,
                  child: CupertinoSlidingSegmentedControl(
                    groupValue: segmentedControlValue,
                    backgroundColor: Color(0x1abc322d),
                    children: {
                      0: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Overview',
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
                          'Review',
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
                          'Product',
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
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Mail",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(
            height: 5,
          ),
          Text(Details["email"] ?? "",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 20,
          ),
          Text("Phone No.",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(
            height: 5,
          ),
          Text(Details["phone"] ?? "",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 20,
          ),
          Text("Address",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
          SizedBox(
            height: 5,
          ),
          Text(Details["location"] ?? "____",
              style: GoogleFonts.dmSans(
                color: Color(0xff000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
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
                  Type: "User",
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
        (Details["reviwes"].isNotEmpty)
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Details["reviwes"].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage((Details["reviwes"][index]
                                    ["user_logo"] ==
                                null)
                            ? "https://cdn.vectorstock.com/i/preview-1x/66/14/default-avatar-photo-placeholder-profile-picture-vector-21806614.jpg"
                            : "https://deadstock.webkype.co/public/user/${Details["reviwes"][index]["user_logo"]}")),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StarRating(
                            color: Color(0xc0bc322d),
                            mainAxisAlignment: MainAxisAlignment.start,
                            length: 5,
                            rating: double.parse(
                                Details["reviwes"][index]["rating"]),
                            between: 5,
                            starSize: 20,
                            onRaitingTap: (rating) {},
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${Details["reviwes"][index]["name"]} on ${DateFormat('dd MMM y').format(DateTime.parse(Details["reviwes"][index]["created_at"]))}",
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
                      Details["reviwes"][index]["review"],
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
                    top: MediaQuery.of(context).size.height / 5),
                child: Text("Nothing to show",
                    style: GoogleFonts.dmSans(
                      color: const Color(0xff535353),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )))
      ]);
    } else {
      return (Details["services"].isNotEmpty)
          ? ListView.builder(
              itemCount: Details["services"].length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return DetailScreen(
                        Id: Details["services"][index]["id"].toString(),
                      );
                    }));
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    child: Container(
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
                                        "https://deadstock.webkype.co/public/ad/${Details["services"][index]["logo"]}"),
                                    fit: BoxFit.fitWidth)),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${Details["services"][index]["title"]}",
                                      style: GoogleFonts.dmSans(
                                        color: Color(0xff000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Text(
                                      "₹ ${Details["services"][index]["price"]}",
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xff535353),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  Text(
                                      "${Details["services"][index]["description"]}",
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
                  ),
                );
              })
          : Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 5),
              child: Text("Nothing to show",
                  style: GoogleFonts.dmSans(
                    color: const Color(0xff535353),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )));
    }
  }

  Future DetailApi() async {
    var response = await https.get(Uri.parse(
        "https://deadstock.webkype.co/api/provider_detail/${widget.Id}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          Details = data["data"];
          isActive = false;
        });
      }
    }
  }
}
