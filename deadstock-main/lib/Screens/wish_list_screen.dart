import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as https;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  bool isActive = false;
  List WishList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    WishListAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Wishlist",
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
            : (WishList.isNotEmpty)
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: WishList.length,
                            itemBuilder: (context, index) {
                              return Stack(children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 15,
                                    left: 10,
                                    right: 10,
                                  ),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    "https://deadstock.webkype.co/public/ad/${WishList[index]["image"]}"),
                                                fit: BoxFit.fitWidth)),
                                      ),
                                      Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(children: [
                                                Expanded(
                                                  child: Text(
                                                      WishList[index]["title"],
                                                      style: GoogleFonts.dmSans(
                                                        color:
                                                            Color(0xff000000),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                              ]),
                                              Text(
                                                  "₹ ${WishList[index]["price"]}",
                                                  style: GoogleFonts.dmSans(
                                                    color:
                                                        const Color(0xff535353),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                              Text(
                                                  "${WishList[index]["description"]}",
                                                  maxLines: 3,
                                                  style: GoogleFonts.dmSans(
                                                    color:
                                                        const Color(0xff535353),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ]),
                                      ),
                                    ]),
                                  ]),
                                ),
                                Positioned(
                                    right: 12,
                                    top: 9,
                                    child: GestureDetector(
                                      onTap: () {
                                        RemoveAPI(WishList[index]["wishId"]
                                            .toString());
                                      },
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    ))
                              ]);
                            }),
                      ],
                    ),
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

  Future WishListAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https
        .get(Uri.parse("https://deadstock.webkype.co/api/wish_list/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          WishList = data["wishlist"];
          isActive = false;
        });
      }
    }
  }

  Future RemoveAPI(String ID) async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            color: Color(0xffbc322d),
            strokeWidth: 1.5,
          ));
        });
    var response = await https.get(
        Uri.parse("https://deadstock.webkype.co/api/removefromwish/${ID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        await WishListAPI();
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
}
