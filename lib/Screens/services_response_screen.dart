import 'dart:convert';
import 'package:http/http.dart' as https;
import 'package:deadstock/Screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServicesResponses extends StatefulWidget {
  const MyServicesResponses({super.key});

  @override
  State<MyServicesResponses> createState() => _MyServicesResponsesState();
}

class _MyServicesResponsesState extends State<MyServicesResponses> {
  bool isActive = false;
  List ResponseList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isActive = true;
    });
    ResponseListApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Service Responses",
              style: GoogleFonts.dmSans(
                color: Color(0xffffffff),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              )),
          backgroundColor: Color(0x80bc322d),
          automaticallyImplyLeading: false,
          elevation: 0,
          leadingWidth: 35,
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
            : (ResponseList.isNotEmpty)
                ? ListView.builder(
                    itemCount: ResponseList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: 7.5, left: 10, right: 10, top: 7.5),
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
                                            "https://deadstock.webkype.co/public/ad/${ResponseList[index]["logo"]}"),
                                        fit: BoxFit.fitWidth)),
                              ),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${ResponseList[index]["title"]}",
                                          style: GoogleFonts.dmSans(
                                            color: Color(0xff000000),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text("₹ ${ResponseList[index]["price"]}",
                                          style: GoogleFonts.dmSans(
                                            color: const Color(0xff535353),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(
                                          "${ResponseList[index]["description"]}",
                                          maxLines: 3,
                                          style: GoogleFonts.dmSans(
                                            color: const Color(0xff535353),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ]),
                              ),
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${ResponseList[index]["response_count"]} Responses",
                                      style: GoogleFonts.dmSans(
                                        color: const Color(0xff535353),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  (ResponseList[index]["response_count"] != 0)
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ChatScreen(ID: ResponseList[index]["id"].toString());
                                            }));
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 7),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    Color(0xcdbc322d),
                                                    Color(0x80bc322d),
                                                  ],
                                                ),
                                              ),
                                              child: Row(children: [
                                                Text(
                                                  "View",
                                                  style: GoogleFonts.dmSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 15,
                                                )
                                              ])),
                                        )
                                      : Container(),
                                ]),
                          ]),
                        ),
                      );
                    })
                : Center(
                    child: Text("Your Don't post any service yet!!",
                        style: GoogleFonts.dmSans(
                          color: const Color(0xff535353),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ))));
  }

  Future ResponseListApi() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var UID = preferences.getString("UserID");
    var response = await https.get(
        Uri.parse("https://deadstock.webkype.co/api/service_response/${UID}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        setState(() {
          ResponseList = data["response"];
          isActive = false;
        });
      }
    }
  }
}
